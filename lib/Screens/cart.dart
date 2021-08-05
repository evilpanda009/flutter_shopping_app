import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Screens/productInfo.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/button.dart';
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
  late List? dataAll;
  late var res;
  Button button = Button();
  // @override
  // void initState() {
  //   super.initState();
  //   getCart();
  // }
  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  final Shader txtgradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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
        .orderBy('id')
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

                  return FutureBuilder(
                      future: getData(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data != null) {
                            //res = snapshot.data as DocumentSnapshot ;
                            dataAll = snapshot.data!.docs;
                            List data = [];
                            for (int i = 0; i < dataAll!.length; i++) {
                              if (ds.cart!
                                  .contains(dataAll![i]['id'].toString()))
                                data.add(dataAll![i]);
                            }
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        foreground: Paint()
                                          ..shader = txtgradient1)),
                                backgroundColor: Colors.white,
                                actions: [
                                  IconButton(
                                      color: Colors.deepOrange,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/history');
                                      },
                                      icon: Icon(Icons.history))
                                ],
                                elevation: 0,
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
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 6,
                                              spreadRadius: 3,
                                              offset: Offset(0, 3))
                                        ],
                                      ),
                                      height: 55,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8, left: 20),
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Expanded(
                                      child: Stack(children: [
                                        Expanded(
                                          child: ScrollConfiguration(
                                            behavior: MyBehavior(),
                                            child: ListView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: ds.cart!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  id = int.parse((data[index]
                                                          ['id'])
                                                      .toString());

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8,
                                                            right: 12,
                                                            left: 12),
                                                    child: Dismissible(
                                                      key: Key(data[index]['id']
                                                          .toString()),
                                                      background: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 40.0),
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Icon(Icons
                                                                  .delete)),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                      ),
                                                      onDismissed:
                                                          (direction) async {
                                                        String id = data[index]
                                                                ['id']
                                                            .toString();
                                                        print("DELETING $id");
                                                        ds.cart!.remove(
                                                            id.toString());
                                                        await ds.removeFromCart(
                                                            id.toString());

                                                        setState(() {
                                                          String deletedId =
                                                              id.toString();
                                                          String deletedTitle =
                                                              data[index]
                                                                  ['title'];
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .clearSnackBars();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Removed $deletedTitle from Cart",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              action:
                                                                  SnackBarAction(
                                                                      label:
                                                                          "UNDO",
                                                                      onPressed:
                                                                          () async {
                                                                        ds.cart!
                                                                            .add(deletedId);

                                                                        await undoDelete(
                                                                            id.toString());
                                                                        setState(
                                                                            () {});
                                                                      } // this is what you needed
                                                                      ),
                                                            ),
                                                          );
                                                        });
                                                      },
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          id = int.parse(
                                                              data[index]['id']
                                                                  .toString());
                                                          Navigator.pushNamed(
                                                                  context,
                                                                  '/product',
                                                                  arguments:
                                                                      data[
                                                                          index])
                                                              .then((value) => {
                                                                    setState(
                                                                        () {})
                                                                  });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        blurRadius:
                                                                            2,
                                                                        spreadRadius:
                                                                            1,
                                                                        offset: Offset(
                                                                            0,
                                                                            3))
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                    height: 150,
                                                                    padding: EdgeInsets.all(8),
                                                                    child: Padding(
                                                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 10),
                                                                        child: Image.network(data[index]['image'], errorBuilder: (context, error, stackTrace) {
                                                                          return Image.asset(
                                                                              'assets/cart.jpg');
                                                                        }))),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            [
                                                                            'title'],
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    FractionallySizedBox(
                                                                      widthFactor:
                                                                          1,
                                                                      child: Row(
                                                                          children: [
                                                                            Text(
                                                                              "\$ " + data[index]['price'].toString(),
                                                                              overflow: TextOverflow.fade,
                                                                            ),
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  id = int.parse(data[index]['id'].toString());
                                                                                  int quant = ds.quantity![ds.cart!.indexOf(id.toString())];
                                                                                  if (quant == 1) {
                                                                                    return null;
                                                                                  }
                                                                                  quant = quant - 1;
                                                                                  await ds.changeQuantity(id.toString(), quant);
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(Icons.remove)),
                                                                            Text(
                                                                              ds.quantity![ds.cart!.indexOf(id.toString())].toString(),
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  id = int.parse(data[index]['id'].toString());
                                                                                  int quant = ds.quantity![ds.cart!.indexOf(id.toString())];
                                                                                  quant = quant + 1;
                                                                                  await ds.changeQuantity(id.toString(), quant);
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(Icons.add)),
                                                                          ]),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: TextButton
                                                                          .icon(
                                                                        style: ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.white)),
                                                                        onPressed:
                                                                            () {
                                                                          id = int.parse(
                                                                              data[index]['id'].toString());
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                    title: Text("Remove from Cart?"),
                                                                                    content: Text("The item will no longer appear in your cart."),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text("Cancel")),
                                                                                      TextButton(
                                                                                          onPressed: () async {
                                                                                            ds.cart!.remove(id.toString());
                                                                                            Navigator.of(context).pop();
                                                                                            await ds.removeFromCart(id.toString());
                                                                                            setState(() {});
                                                                                          },
                                                                                          child: Text("Remove", style: TextStyle(color: Colors.red)))
                                                                                    ],
                                                                                  ));
                                                                        },
                                                                        icon: Icon(
                                                                            Icons
                                                                                .delete_outline,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.red),
                                                                        label:
                                                                            Text(
                                                                          "Remove",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
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
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.52,
                                          child: Material(
                                            elevation: 5,
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              splashColor: Colors.pink,
                                              onTap: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              "Order Summary"),
                                                          content: Text(
                                                              "Pay on delivery\nTotal amount to be paid:  \$ ${total.toStringAsFixed(2)}"),
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
                                                                  await ds.orderHistory(
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

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    "Place order"))
                                                          ],
                                                        ));
                                              },
                                              child: Ink(
                                                width: 260,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  gradient: myGradient,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Container(
                                                  color: Colors.transparent,

                                                  constraints: const BoxConstraints(
                                                      minWidth: 88.0,
                                                      minHeight:
                                                          36.0), // min sizes for Material buttons
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white),
                                                      Text('Checkout',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white)),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),

                                    //ElevatedButton.icon(
                                    // icon: Icon(Icons.arrow_forward),
                                    //label: Text("Checkout"),
                                    // onPressed: () {
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) => AlertDialog(
                                    //           title:
                                    //               Text("Order Summary"),
                                    //           content: Text(
                                    //               "Pay on delivery\nTotal amount to be paid:  \$ ${total.toStringAsFixed(2)}"),
                                    //           actions: [
                                    //             TextButton(
                                    //                 onPressed: () {
                                    //                   Navigator.of(
                                    //                           context)
                                    //                       .pop();
                                    //                 },
                                    //                 child:
                                    //                     Text("Cancel")),
                                    //             TextButton(
                                    //                 onPressed: () async {
                                    //                   await ds
                                    //                       .orderHistory(
                                    //                           names,
                                    //                           prices,
                                    //                           ds.quantity,
                                    //                           total);

                                    //                   Navigator.of(
                                    //                           context)
                                    //                       .pop();
                                    //                   // for (int i = 0;
                                    //                   //     i <=
                                    //                   //         ds.cart!
                                    //                   //             .length;
                                    //                   //     i++) {
                                    //                   //   await ds
                                    //                   //       .removeFromCart(ds
                                    //                   //           .cart![i]
                                    //                   //           .toString());
                                    //                   // }
                                    //                   await ds
                                    //                       .clearCart();

                                    //                   setState(() {});
                                    //                 },
                                    //                 child: Text(
                                    //                     "Place order"))
                                    //           ],
                                    //         ));
                                    //  },
                                    // ),
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
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff3f0ec),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            "Cart",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                foreground: Paint()..shader = txtgradient1),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                icon: Icon(
                  Icons.history,
                  color: Colors.deepOrange,
                )),
          )
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

