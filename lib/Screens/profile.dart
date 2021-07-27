import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final DatabaseService ds = DatabaseService();
  final db = FirebaseFirestore.instance;
  late String name, email;
  bool loading = true;

  // String getName() {
  //   final userId = _auth.getUser();
  //   print(userId);
  //   db
  //       .collection('users')
  //       .doc(userId.toString())
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       return documentSnapshot.data();
  //     }
  //   });
  //   return "";
  // }
  @override
  void initState() {
    super.initState();
    var user = _auth.getUser().toString();

    db
        .collection('users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data());
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          name = data['name'].toString();
          email = data['email'].toString();
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            color: Color(0xfff3f0ec),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //CircleAvatar(backgroundImage: _auth.,)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(
                        width: 10,
                      ),
                      Text(email, style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text("Sign Out"),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
