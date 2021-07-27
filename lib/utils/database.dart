import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/utils/auth.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String name;
  AuthService auth = AuthService();
  bool loading = true;
  CollectionReference UserCollection =
      FirebaseFirestore.instance.collection('users');
  var User = AuthService().getUser().toString();

  Stream<QuerySnapshot> get Data {
    return UserCollection.snapshots();
  }

  List? cart;
  List? fav;

  Future<void> getUserData() async {
    var user = auth.getUser().toString();
    await db
        .collection('users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        cart = data['cart'];
        fav = data['fav'];
        if (cart == null) cart = [];
        if (fav == null) fav = [];

        print(cart);
        print(fav);
      }
    }).catchError((error) {
      print(error);
      return null;
    });
  }

  Future<void> addtoCart(String id) async {
    var user = auth.getUser().toString();
    try {
      await getUserData();
      cart!.add(id);

      await db.collection('users').doc(user).update({
        'cart': cart,
      }).then((val) => print("Item added to cart" + cart.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> removeFromCart(String id) async {
    try {
      await getUserData();
      cart!.remove(id);

      await db.collection('users').doc(User).update({
        'cart': cart,
      }).then((val) => print("Item removed from cart" + cart.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addtoFav(String id) async {
    var user = auth.getUser().toString();
    try {
      await getUserData();
      fav!.add(id);

      await db.collection('users').doc(user).update({
        'fav': fav,
      }).then((val) => print("Item added to favorites" + fav.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> removeFromFav(String id) async {
    try {
      await getUserData();
      fav!.remove(id);

      await db.collection('users').doc(User).update({
        'fav': fav,
      }).then((val) => print("Item removed from favorites" + fav.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}

class AddUser {
  final String fullName;
  final String email;

  AddUser(
    this.fullName,
    this.email,
  );

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  var userid;

  void inputData() {
    final User? user = _auth.currentUser;
    userid = user!.uid;
  }

  Future addUser() async {
    inputData();

    int documentId = 1;

    Query colRef = users.orderBy('timestamp', descending: true).limit(1);

    await colRef.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0 || querySnapshot.docs.isEmpty) {
        documentId = 1;
      } else {
        querySnapshot.docs.forEach((doc) {
          print(doc['id']);
          documentId = doc['id'] + 1;
        });
      }
    }).catchError((error) => null);

    bool check = true;

    await users
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0 || querySnapshot.docs.isEmpty) {
        check = true;
      } else
        check = false;
    }).catchError((error) {
      check = true;
    });

    // Call the user's CollectionReference to add a new user

    return check
        ? await users
            .doc(userid.toString())
            .set({
              'name': fullName, // John Doe
              'id': documentId, // id
              'email': email,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'cart': [],
              'fav': [],
            })
            .then((value) => value)
            .catchError((error) => null)
        : null;
  }
}
