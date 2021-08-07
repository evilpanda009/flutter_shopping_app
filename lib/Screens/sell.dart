import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:flutter/services.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  DatabaseService ds = DatabaseService();

  static var user = AuthService().getUser().toString();

  @override
  void initState() {
    //this.getCurrentUser();

    super.initState();
    user = AuthService().getUser().toString();
  }

  static User? _user;

  // _SellState() {
  // user = AuthService().getUser().toString();
  // }

  // void getCurrentUser() {
  //   _user = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     _user!.uid;
  //   });
  // calling setState allows widgets to access uid and access stream
  //}
  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .orderBy('id')
      .snapshots();
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 60,
        title: Text(
          "Sell Products",
          style: TextStyle(
              foreground: Paint()..shader = txtgradient1,
              fontSize: 30,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                tooltip: "Sell new product",
                onPressed: () {
                  Navigator.pushNamed(context, '/sellItem');
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 28,
                )),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              var finalData = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Object?>> data = [];
              for (var doc in finalData) {
                if ((doc.data()! as Map<String, dynamic>)['user'] ==
                    user.toString()) {
                  data.add(doc);
                  print(data[0]);
                }
              }
              if (data.length == 0) return EmptySell();

              return ListView.builder(
                  key: PageStorageKey('Sell'),
                  physics: BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/product',
                                arguments: data[index])
                            .then((value) => {setState(() {})});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(0, 3))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                    height: 150,
                                    //padding: EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/loading2.gif',
                                            image: data[index]['image'],
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/no-internet.gif',
                                                fit: BoxFit.contain,
                                              );
                                            }),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]['title'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("\$ " +
                                            data[index]['price'].toString()),
                                      ),
                                      //SizedBox(height: 10,),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton.icon(
                                              style: ButtonStyle(),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              "Delete Product?"),
                                                          content: Text(
                                                              "Are you sure you want to delete this product from the market, this action is irreversible!"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    "Cancel")),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  await ds.deleteProduct(
                                                                      data[index]
                                                                              [
                                                                              'id']
                                                                          .toString());
                                                                },
                                                                child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)))
                                                          ],
                                                        ));
                                              },
                                              icon: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                  Icons.delete_outlined,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              label: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/edit',
                                                  arguments: data[index]);
                                            },
                                            icon: Icon(Icons.edit),
                                            splashRadius: 3,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }

            return EmptySell();
            // } else
            //   return Loading();
          }),
    );
  }
}

class EmptySell extends StatelessWidget {
  const EmptySell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width / 2), top: 30),
              child: Image.asset("assets/arrow.jpg"),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  "Sell a product on Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
                child: Container(
                    height: 300,
                    child: Image.asset('assets/featured-products.jpg')))
          ],
        ),
      ),
    );
  }
}
