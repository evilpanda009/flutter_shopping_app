import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/utils/database.dart';

class ProductInfo extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductInfo> {
  bool toggleCart = false;
  bool toggleFav = false;
  DatabaseService ds = DatabaseService();
  late List<dynamic>? cart, fav;
  late var productData;
  late DocumentSnapshot documentSnapshot;

  void listCointains(List? list) {
    for (int i = 0; i < list!.length; i++) {
      print(list[i] + "   " + productData['id'].toString());
      if (list[i] == productData['id'].toString()) {
        if (list == ds.cart)
          toggleCart = true;
        else
          toggleFav = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    get();
    //   fav = ds.fav;
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> get() async {
    await ds.getUserData();
    listCointains(ds.cart);
    listCointains(ds.fav);
    //print("hoooray");
    print(ds.cart);
    print(ds.fav);
    return null;
  }

  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  );
  final LinearGradient gradient1 = LinearGradient(
    colors: <Color>[Colors.orange[100]!, Colors.pink[100]!],
  );
  DateTime? loginClickTime;

  bool isRedundentClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
    if (currentTime.difference(loginClickTime!).inSeconds < 1) {
      //set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    documentSnapshot =
        ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    productData = documentSnapshot.data();
    int index = productData['id'] - 1;

    // setState(() {
    //   if (ds.cart != null) {
    //     for (int i = 0; i < ds.cart!.length; i++) {
    //       print(ds.cart![i] + "   " + productData['id'].toString());
    //       if (ds.cart![i] == productData['id'].toString()) {
    //         toggleCart = true;
    //       }
    //     }
    //   }
    //   if (ds.fav != null) {
    //     for (int i = 0; i < ds.fav!.length; i++) {
    //       print(ds.fav![i] + "   " + productData['id'].toString());
    //       if (ds.fav![i] == productData['id'].toString()) {
    //         toggleFav = true;
    //       }
    //     }
    //   }
    // });

    return FutureBuilder(
        future: get(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   onPressed: () async {
              //     Navigator.pop(context, productData['id']) as int;
              //     return productData['id'];
              //   },
              // ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: 3);
                    },
                    icon: Icon(Icons.shopping_cart))
              ],
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            //extendBodyBehindAppBar: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                //alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 20, right: 20),
                            child: Hero(
                              tag: "product" + index.toString(),
                              child: FadeInImage.assetNetwork(
                                  image: productData['image'],
                                  placeholder: 'assets/loading2.gif',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/no-internet.gif',
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.4,
                          maxChildSize: 0.85,
                          builder: (context, scrollcontroller) {
                            return ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                controller: scrollcontroller,
                                child: Center(
                                  child: Container(
                                    //margin: EdgeInsets.only(
                                    //top: MediaQuery.of(context).size.height / 2.2),
                                    height: MediaQuery.of(context)
                                                .orientation ==
                                            Orientation.portrait
                                        ? MediaQuery.of(context).size.height *
                                            0.78
                                        : 400,
                                    //-
                                    //     MediaQuery.of(context).size.height / 2.2,
                                    decoration: BoxDecoration(
                                      // color: Color(0xffEDAFB8),
                                      // color: Colors.white60,
                                      gradient: gradient1,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey.withOpacity(0.4),
                                      //       offset: Offset(0, -3),
                                      //       spreadRadius: 1,
                                      //       blurRadius: 3)
                                      // ],
                                      borderRadius: BorderRadius.circular(30),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(30),
                                      //     topRight: Radius.circular(30))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 0,
                                          left: 20,
                                          right: 20),
                                      child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                productData['title'],
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '\$ ' +
                                                      productData['price']
                                                          .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                productData['desc'],
                                                style: GoogleFonts.montserrat(),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                            Icons.sell_rounded,
                                                            size: 14),
                                                      ),
                                                      TextSpan(
                                                        text: " " +
                                                            (productData[
                                                                    'category'] ??
                                                                "Miscellaneous"),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("By " +
                                                  (productData['seller'] ??
                                                      "Shopr House")),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(toggleCart
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                      onPressed: () async {
                                                        if (toggleCart ==
                                                            false) {
                                                          if (isRedundentClick(
                                                              DateTime.now())) {
                                                            print(
                                                                'hold on, processing');
                                                            return;
                                                          }
                                                          await ds.addtoCart(
                                                              productData['id']
                                                                  .toString());
                                                        } else
                                                          await ds.removeFromCart(
                                                              productData['id']
                                                                  .toString());
                                                        setState(() {
                                                          toggleCart =
                                                              !toggleCart;
                                                        });
                                                      },
                                                      child: Text(
                                                        toggleCart
                                                            ? 'REMOVE FROM CART'
                                                            : 'ADD TO CART',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 16,
                                                                color: toggleCart
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white),
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80)),
                                                    child: BouncingWidget(
                                                      scaleFactor: 3,
                                                      duration: Duration(
                                                          milliseconds: 270),
                                                      onPressed: () async {
                                                        if (toggleFav ==
                                                            false) {
                                                          if (isRedundentClick(
                                                              DateTime.now())) {
                                                            print(
                                                                'hold on, processing');
                                                            return;
                                                          }
                                                          await ds.addtoFav(
                                                              productData['id']
                                                                  .toString());
                                                        } else
                                                          await ds.removeFromFav(
                                                              productData['id']
                                                                  .toString());
                                                        setState(() {
                                                          toggleFav =
                                                              !toggleFav;
                                                        });
                                                      },
                                                      child: Icon(
                                                        toggleFav
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
