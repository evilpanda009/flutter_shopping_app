import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String name;
  AuthService auth = AuthService();
  bool loading = true;
  CollectionReference UserCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference ProductCollection =
      FirebaseFirestore.instance.collection('products');
  var User = AuthService().getUser().toString();

  Reference storageRef = FirebaseStorage.instance.ref();

  // Stream<List<ProductData>> get productStream {
  //   return ProductCollection.snapshots().map(listOfProducts);
  // }

  Future<void> addProducts(data) async {
    for (int i = 0; i < data.length; i++) {
      await db.collection('products').doc(data[i]['id'].toString()).set({
        'id': data[i]['id'],
        'title': data[i]['title'],
        'desc': data[i]['description'],
        'price': data[i]['price'],
        'image': data[i]['image'],
        'category': data[i]['category']
      }).then((value) => value);
    }
  }

  Future uploadImage(XFile? image) async {
    var file = File(image!.path);
    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await storageRef.child('product/${Uuid().v4()}.jpg').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl.toString();
    } else {
      print('No Image Path Received');
    }
  }

  Future<void> orderHistory(
      List? names, List? prices, List? quantity, totalprice) async {
    await db.collection('carts').add({
      'names': names,
      'prices': prices,
      'quantity': quantity,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'user': User,
      'total': totalprice
    }).then((value) => null);
  }

  Future<void> clearCart() async {
    await db.collection('users').doc(User).update({
      'cart': [],
      'quantity': [],
    }).then((value) => null);
  }

  Future<void> addProduct(ProductData? data) async {
    int id = 99;
    await db
        .collection('products')
        .orderBy('id', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0 || querySnapshot.docs.isEmpty) {
        return 1;
      } else {
        querySnapshot.docs.forEach((doc) {
          print("========================" + doc['id'].toString());
          id = doc['id'] + 1;
        });
      }
    }).catchError((error) {
      print(error.toString());
    });

    if (data != null)
      await db
          .collection('products')
          .doc(id.toString())
          .set({
            'id': id,
            'title': data.title,
            'desc': data.desc,
            'price': data.price,
            'image': data.image,
            'category': data.category ?? "Miscellaneous",
            'user': auth.getUser().toString()
          })
          .then((value) => null)
          .onError((error, stackTrace) => null);
  }

  //Future getProduct() async {}
  Future getProduct(String id) async {
    return await db.collection('products').doc(id).get().then((value) => value);
  }

  Future updateProduct(ProductData? data) async {
    if (data != null) {
      var product = await getProduct(data.id.toString());
      await db.collection('products').doc(data.id.toString()).update({
        'title': data.title ?? product['title'],
        'desc': data.desc ?? product['desc'],
        'price': data.price ?? product['price'],
        'category': data.category ?? product['category'],
      }).then((value) => print("Product updated"));
      if (data.image != null)
        await db.collection('products').doc(data.id.toString()).update({
          'image': data.image ?? product['image'],
        }).then((value) => print("image updated"));
    }
  }

  List? cart;
  List? fav;
  List? quantity;

  // List<ProductData> listOfProducts(QuerySnapshot querySnapshot) {
  //   return querySnapshot.docs.map((doc) {
  //     var data = doc.data() as Map<String, dynamic>;
  //     return ProductData(
  //         id: data['id'].toString(),
  //         title: data['title'],
  //         desc: data['desc'],
  //         price: data['price']);
  //   }).toList();
  // }
  final String url = 'https://fakestoreapi.com/products';

  Future<void> getUserData() async {
    var user = auth.getUser().toString();

    //Response res = await get(Uri.parse(url));

    //await addProducts(jsonDecode(res.body));
    await db
        .collection('users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        cart = data['cart'] ?? [];
        fav = data['fav'] ?? [];
        quantity = data['quantity'] ?? [];
        // if (cart == null) cart = [];
        // if (fav == null) fav = [];

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
      quantity!.add(1);

      await db
          .collection('users')
          .doc(user)
          .update({'cart': cart, 'quantity': quantity}).then(
              (val) => print("Item added to cart" + cart.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> changeQuantity(String id, int quant) async {
    var user = auth.getUser().toString();
    try {
      await getUserData();
      quantity!.replaceRange(cart!.indexOf(id), cart!.indexOf(id) + 1, [quant]);

      await db
          .collection('users')
          .doc(user)
          .update({'quantity': quantity}).then(
              (val) => print("Item added to cart" + cart.toString()));
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> removeFromCart(String id) async {
    try {
      await getUserData();
      await quantity!.removeAt(cart!.indexOf(id));
      cart!.remove(id);

      await db
          .collection('users')
          .doc(User)
          .update({'cart': cart, 'quantity': quantity}).then(
              (val) => print("Item removed from cart" + cart.toString()));
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> deleteProduct(String id) async {
    await getUserData();
    await db.collection('products').doc(id).delete();
    await db.collection('users').get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) async {
          await removeFromCart(doc.id);
          await removeFromFav(doc.id);
        });
      }
    });
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
              'quantity': []
            })
            .then((value) => value)
            .catchError((error) => null)
        : null;
  }
}
