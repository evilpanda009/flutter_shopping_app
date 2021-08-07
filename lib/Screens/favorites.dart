import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Screens/productInfo.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';

class Favorites extends StatefulWidget {
  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Favorites> {
  DatabaseService ds = DatabaseService();
  ApiRequests api = ApiRequests();
  bool isEmpty = false;
  late List? dataAll;
  late var res;
  // @override
  // void initState() {
  //   super.initState();
  //   getFav();
  // }

  Future getFav() async {
    await ds.getUserData();
    if (ds.fav == null || ds.fav!.length == 0) return null;

    return ds.fav;
  }

  Future<void> undoDelete(String id) async {
    await ds.addtoFav(id);
  }

  Future<QuerySnapshot> getData() async {
    // final String url = 'https://fakestoreapi.com/products';
    // return await get(Uri.parse(url));
    return await FirebaseFirestore.instance
        .collection('products')
        .orderBy('id')
        .get();
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool undo = false;
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    int id;

    return !isEmpty
        ? FutureBuilder(
            future: getFav(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasData && snap.data != null && snap.data != []) {
                  return FutureBuilder(
                      future: getData(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            dataAll =
                                snapshot.data!.docs as List<DocumentSnapshot>;
                            List? data = [];
                            for (int i = 0; i < dataAll!.length; i++) {
                              if (ds.fav!
                                  .contains(dataAll![i]['id'].toString()))
                                data.add(dataAll![i]);
                            }
                            // print("Data" + data.length.toString());
                            // print("Favsss" + ds.fav!.length.toString());
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "My Favorites ",
                                  style: TextStyle(
                                      fontSize: 35,
                                      foreground: Paint()
                                        ..shader = txtgradient1,
                                      fontWeight: FontWeight.w700),
                                ),
                                elevation: 5,
                              ),
                              key: _key,
                              body: ListView.builder(
                                  key: PageStorageKey("Favorites"),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    id =
                                        int.parse(data[index]['id'].toString());

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6.0,
                                          bottom: 6,
                                          left: 18,
                                          right: 18),
                                      child: Dismissible(
                                        key: Key(data[index]['id'].toString()),
                                        background: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 40.0),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(Icons.delete)),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                        ),
                                        onDismissed: (direction) async {
                                          String id =
                                              data[index]['id'].toString();
                                          print("DELETING $id");
                                          ds.fav!.remove(id.toString());
                                          await ds.removeFromFav(id.toString());

                                          setState(() {
                                            String deletedId = id.toString();
                                            String deletedTitle =
                                                data[index]['title'];
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Removed $deletedTitle from favorites",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                action: SnackBarAction(
                                                    label: "UNDO",
                                                    onPressed: () async {
                                                      ds.fav!.add(deletedId);
                                                      undo = true;
                                                      await undoDelete(
                                                          id.toString());
                                                      setState(() {});
                                                    } // this is what you needed
                                                    ),
                                              ),
                                            );
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            id = int.parse(
                                                (data[index]['id']).toString());
                                            Navigator.pushNamed(
                                                    context, '/product',
                                                    arguments: data[index])
                                                .then((value) =>
                                                    {setState(() {})});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2,
                                                      spreadRadius: 1,
                                                      offset: Offset(0, 3))
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      height: 150,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8.0,
                                                                bottom: 8,
                                                                left: 8,
                                                                right: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                              data[index]
                                                                  ['image'],
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                            return Image.asset(
                                                                'assets/cart.jpg');
                                                          }),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            data[index]
                                                                ['title'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "\$ " +
                                                              data[index]
                                                                      ['price']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color: Colors.red,
                                                            size: 28,
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          title:
                                                                              Text("Remove from Favorites?"),
                                                                          content:
                                                                              Text("The item will no longer appear in your Favorites."),
                                                                          actions: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text("Cancel")),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  Navigator.of(context).pop();
                                                                                  await ds.removeFromFav(id.toString());
                                                                                  setState(() {});
                                                                                },
                                                                                child: Text("Remove", style: TextStyle(color: Colors.red)))
                                                                          ],
                                                                        ));
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                          return Empty();
                        }
                        return Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepOrange));
                      });
                }
                return Empty();
              }
              return Center(
                  child: CircularProgressIndicator(color: Colors.deepOrange));
            })
        : Empty();
  }
}

class Empty extends StatefulWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          constraints: BoxConstraints.expand(),
          color: Color(0xfff3f0ec),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Favorites",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      foreground: Paint()..shader = txtgradient1),
                ),
              )),
              Expanded(
                flex: 4,
                child: Container(
                  child: Image.asset(
                    'assets/heart.jpg',
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                      "Looks empty,\nGo add some stuff to your favorites!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5),
                  child: Image.asset(
                    'assets/right-drawn-arrow.jpg',
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

// class CartList extends StatefulWidget {
//   const CartList({ Key? key }) : super(key: key);

//   @override
//   _CartListState createState() => _CartListState();
// }

// class _CartListState extends State<CartList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: ds.cart!.length,
//       itemBuilder: (BuildContext context, index) {
//         return Container(
//           child: Row(children: [
//             Image.network(ds.)
//           ],),
//         )
//       })
//     );
//   }
// }
