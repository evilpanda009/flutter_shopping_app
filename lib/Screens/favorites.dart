import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
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
  late Response res;
  @override
  void initState() {
    super.initState();
    getFav();
  }

  Future getFav() async {
    await ds.getUserData();
    if (ds.fav == null || ds.fav!.length == 0) return null;

    return ds.fav;
  }

  Future<Response> getData() async {
    final String url = 'https://fakestoreapi.com/products';
    return await get(Uri.parse(url));
  }

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
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            res = snapshot.data as Response;
                            data = jsonDecode(res.body);
                            return ListView.builder(
                                itemCount: ds.fav!.length,
                                itemBuilder: (BuildContext context, index) {
                                  id = int.parse((ds.fav![index]).toString());
                                  return Container(
                                    child: Image.network(data[id - 1]['image']),
                                  );
                                });
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
                    'assets/cart.jpg',
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
                      left: MediaQuery.of(context).size.width / 3.5),
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
