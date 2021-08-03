import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  DatabaseService ds = DatabaseService();
  ApiRequests api = ApiRequests();
  bool isEmpty = false;
  late var data;
  late var res;
  // @override
  // void initState() {
  //   super.initState();
  //   getCart();
  // }

  Future getCart() async {
    await ds.getUserData();
    if (ds.cart == null || ds.cart == [] || ds.cart!.length == 0) return null;
    // setState(() {
    //   isEmpty = true;
    // });
    return ds.cart;
  }

  Future<void> undoDelete(String id) async {
    await ds.addtoCart(id);
  }

  Future<QuerySnapshot> getData() async {
    // final String url = 'https://fakestoreapi.com/products';
    // return await get(Uri.parse(url));
    return FirebaseFirestore.instance
        .collection('products')
        .where('id', whereIn: ds.cart)
        .get();
  }

  double total = 0;
  List names = [];

  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    int id;
    total = 0;
    names = [];
    List prices = [];
    var totalItems;
    setState(() {});
    return !isEmpty
        ? FutureBuilder(
            future: getCart(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasData && snap.data != null) {
                  print("Not null");
                  List cart = [];
                  for (int i = 0; i < ds.cart!.length; i++)
                    cart.add(int.parse(ds.cart![i].toString()));
                  print(cart);
                  var chunk = [];
                  for (var i = 0; i < ds.cart!.length; i += 10) {
                    chunk.add(cart.sublist(
                        i, i + 2 > cart.length ? cart.length : i + 10));
                  }

                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .where('id', whereIn: cart.toList())
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data != null) {
                            //res = snapshot.data as DocumentSnapshot ;
                            data = snapshot.data!.docs;
                            //print(data.toString());
                            for (int i = 0; i < ds.cart!.length; i++) {
                              print(data[i]['id']);
                              total = total +
                                  data[i]['price'] *
                                      int.parse(ds.quantity![ds.cart!.indexOf(
                                              data[i]['id'].toString())]
                                          .toString());
                              names.add(data[i]['title']);
                              prices.add(data[i]['price']);
                            }
                            totalItems = ds.quantity!.reduce((a, b) => a + b);

                            return Scaffold(
                              appBar: AppBar(
                                title: Text("Cart: $totalItems Items",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700)),
                                shadowColor: Colors.grey,
                                backgroundColor: Colors.black,
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/history');
                                      },
                                      icon: Icon(Icons.history))
                                ],
                                elevation: 10,
                              ),
                              key: _key,
                              body: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 3,
                                              spreadRadius: 3,
                                              offset: Offset(0, 3))
                                        ],
                                      ),
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Total Amount:   \$ ${total.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 10),
                                    //   child: Divider(
                                    //     height: 10,
                                    //     thickness: 5,
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: ds.cart!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            id = int.parse(
                                                (data[index]['id']).toString());

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Dismissible(
                                                key: Key(data[index]['id']
                                                    .toString()),
                                                background: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 40.0),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child:
                                                            Icon(Icons.delete)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                ),
                                                onDismissed: (direction) async {
                                                  String id = data[index]['id']
                                                      .toString();
                                                  print("DELETING $id");
                                                  ds.cart!
                                                      .remove(id.toString());
                                                  await ds.removeFromCart(
                                                      id.toString());

                                                  setState(() {
                                                    String deletedId =
                                                        id.toString();
                                                    String deletedTitle =
                                                        data[index]['title'];
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .clearSnackBars();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Removed $deletedTitle from Cart",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        action: SnackBarAction(
                                                            label: "UNDO",
                                                            onPressed:
                                                                () async {
                                                              ds.cart!.add(
                                                                  deletedId);

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
                                                    id = int.parse(data[index]
                                                            ['id']
                                                        .toString());
                                                    Navigator.pushNamed(
                                                            context, '/product',
                                                            arguments:
                                                                data[index])
                                                        .then((value) =>
                                                            {setState(() {})});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              blurRadius: 3,
                                                              spreadRadius: 3,
                                                              offset:
                                                                  Offset(0, 3))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              height: 150,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      8),
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      bottom: 8,
                                                                      right: 8),
                                                                  child: Image.network(
                                                                      data[index]
                                                                          [
                                                                          'image'],
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                            'assets/cart.jpg');
                                                                  }))),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Align(
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
                                                              SizedBox(
                                                                  height: 20),
                                                              FractionallySizedBox(
                                                                widthFactor: 1,
                                                                child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "\$ " +
                                                                            data[index]['price'].toString(),
                                                                        overflow:
                                                                            TextOverflow.fade,
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            id =
                                                                                int.parse(data[index]['id'].toString());
                                                                            int quant =
                                                                                ds.quantity![ds.cart!.indexOf(id.toString())];
                                                                            if (quant ==
                                                                                1) {
                                                                              return null;
                                                                            }
                                                                            quant =
                                                                                quant - 1;
                                                                            await ds.changeQuantity(id.toString(),
                                                                                quant);
                                                                            setState(() {});
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.remove)),
                                                                      Text(
                                                                        ds.quantity![ds.cart!.indexOf(id.toString())]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            id =
                                                                                int.parse(data[index]['id'].toString());
                                                                            int quant =
                                                                                ds.quantity![ds.cart!.indexOf(id.toString())];
                                                                            quant =
                                                                                quant + 1;
                                                                            await ds.changeQuantity(id.toString(),
                                                                                quant);
                                                                            setState(() {});
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.add)),
                                                                    ]),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () {
                                                                    id = int.parse(data[index]
                                                                            [
                                                                            'id']
                                                                        .toString());
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: Text("Remove from Cart?"),
                                                                              content: Text("The item will no longer appear in your cart."),
                                                                              actions: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text("No")),
                                                                                TextButton(
                                                                                    onPressed: () async {
                                                                                      ds.cart!.remove(id.toString());
                                                                                      Navigator.of(context).pop();
                                                                                      await ds.removeFromCart(id.toString());
                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Text("Yes"))
                                                                              ],
                                                                            ));
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    size: 20,
                                                                  ),
                                                                  label: Text(
                                                                    "Remove",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
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
                                    ),
                                    Container(
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.arrow_forward),
                                        label: Text("Checkout"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        Text("Order Summary"),
                                                    content: Text(
                                                        "Pay on delivery\nTotal amount to be paid:  \$ ${total.toStringAsFixed(2)}"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await ds
                                                                .orderHistory(
                                                                    names,
                                                                    prices,
                                                                    ds.quantity,
                                                                    total);

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            // for (int i = 0;
                                                            //     i <=
                                                            //         ds.cart!
                                                            //             .length;
                                                            //     i++) {
                                                            //   await ds
                                                            //       .removeFromCart(ds
                                                            //           .cart![i]
                                                            //           .toString());
                                                            // }
                                                            await ds
                                                                .clearCart();

                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                              "Place order"))
                                                    ],
                                                  ));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Cart",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              icon: Icon(Icons.history))
        ],
      ),
      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height,
            constraints: BoxConstraints.expand(),
            color: Color(0xfff3f0ec),
            child: Column(
              children: [
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
                    child: Text("Looks empty,\nGo add some stuff to buy!",
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
                        left: (MediaQuery.of(context).size.width / 5)),
                    child: Image.asset(
                      'assets/right-drawn-arrow.jpg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                )
              ],
            )),
      ),
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

class CartHistory extends StatefulWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  _CartHistoryState createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  final user = AuthService().getUser().toString();

  final Stream<QuerySnapshot> history = FirebaseFirestore.instance
      .collection('carts')
      .orderBy('timestamp')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past Orders"),
      ),
      body: StreamBuilder(
          stream: history,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            if (snapshot.hasData) {
              var finalData = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Object?>> data = [];
              for (var doc in finalData) {
                if ((doc.data()! as Map<String, dynamic>)['user'] ==
                    user.toString()) {
                  data.add(doc);
                }
              }
              return Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 5,
                        thickness: 3,
                      );
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var document = data[index];
                      var date = DateTime.fromMillisecondsSinceEpoch(
                          document['timestamp']);
                      var formattedDate = DateFormat('dd-MM-yyyy').format(date);
                      var time = DateFormat.yMEd().add_jms().format(date);
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 30, right: 30),
                        child: SizedBox(
                          height: 270,
                          child: Column(
                            children: [
                              Expanded(
                                child: Text(time.toString()),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(
                                                height: 8,
                                                thickness: 1,
                                              );
                                            },
                                            itemCount:
                                                (data[index]['names'] as List?)!
                                                    .length,
                                            itemBuilder: (context, i) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: Wrap(children: [
                                                      Text(
                                                        document['names'][i],
                                                        //overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ]),
                                                  ),
                                                  Text("x " +
                                                      document['quantity'][i]
                                                          .toString() +
                                                      " "),
                                                  Text(
                                                    (document['prices'][i] *
                                                            document['quantity']
                                                                [i])
                                                        .toStringAsFixed(2),
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 21),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "\$ " +
                                              document['total']
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            return Empty();
          }),
    );
  }
}
