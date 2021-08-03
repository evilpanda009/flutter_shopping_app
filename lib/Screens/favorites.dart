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
  late var data;
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

  @override
  Widget build(BuildContext context) {
    int id;

    return !isEmpty
        ? FutureBuilder(
            future: getFav(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasData && snap.data != null && snap.data != []) {
                  print("Not null");
                  return FutureBuilder(
                      future: getData(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            data =
                                snapshot.data!.docs as List<DocumentSnapshot>;

                            return Scaffold(
                              appBar: AppBar(
                                title: Text("My Favorites "),
                                elevation: 5,
                              ),
                              key: _key,
                              body: ListView.builder(
                                  itemCount: ds.fav!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    id = int.parse((ds.fav![index]).toString());
                                    print(id.toString());

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Dismissible(
                                        key: Key(ds.fav![index].toString()),
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
                                          String id = ds.fav![index].toString();
                                          print("DELETING $id");
                                          ds.fav!.remove(id.toString());
                                          await ds.removeFromFav(id.toString());

                                          setState(() {
                                            String deletedId = id.toString();
                                            String deletedTitle =
                                                data[int.parse(id) - 1]
                                                    ['title'];
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
                                                (ds.fav![index]).toString());
                                            Navigator.pushNamed(
                                                    context, '/product',
                                                    arguments: data[id - 1])
                                                .then((value) =>
                                                    {setState(() {})});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 3,
                                                      spreadRadius: 3,
                                                      offset: Offset(0, 3))
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
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
                                                                right: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                              data[id - 1]
                                                                  ['image']),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          data[id - 1]['title'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text("\$ " +
                                                            data[id - 1]
                                                                    ['price']
                                                                .toString()),
                                                      ),
                                                      ElevatedButton(
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
                                                                                child: Text("No")),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  Navigator.of(context).pop();
                                                                                  await ds.removeFromFav(id.toString());
                                                                                  setState(() {});
                                                                                },
                                                                                child: Text("Yes"))
                                                                          ],
                                                                        ));
                                                          },
                                                          child: Text(
                                                            "Remove",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
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
                        return Center(child: CircularProgressIndicator());
                      });
                }
                return Empty();
              }
              return Center(child: CircularProgressIndicator());
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
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
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
