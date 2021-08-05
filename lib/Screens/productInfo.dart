import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    get();
    //   fav = ds.fav;
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
                              child: Image.network(productData['image'],
                                  errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/no_connection.gif',
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.78,
                                  //-
                                  //     MediaQuery.of(context).size.height / 2.2,
                                  decoration: BoxDecoration(
                                      color: Color(0xff6A66A3),
                                      // gradient: myGradient,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey.withOpacity(0.4),
                                      //       offset: Offset(0, -3),
                                      //       spreadRadius: 1,
                                      //       blurRadius: 3)
                                      // ],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
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
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '\$ ' +
                                                    productData['price']
                                                        .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.orange),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            productData['desc'],
                                            style: GoogleFonts.montserrat(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                productData['category'] ??
                                                    "Miscellaneous",
                                                style: GoogleFonts.montserrat(),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(toggleCart
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black)),
                                                  onPressed: () async {
                                                    if (toggleCart == false)
                                                      await ds.addtoCart(
                                                          productData['id']
                                                              .toString());
                                                    else
                                                      await ds.removeFromCart(
                                                          productData['id']
                                                              .toString());
                                                    setState(() {
                                                      toggleCart = !toggleCart;
                                                    });
                                                  },
                                                  child: Text(
                                                    toggleCart
                                                        ? 'Remove from Cart'
                                                        : 'Add to Cart',
                                                    style: TextStyle(
                                                        color: toggleCart
                                                            ? Colors.black
                                                            : Colors.white),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Material(
                                                  child: IconButton(
                                                      color:
                                                          Colors.pink.shade100,
                                                      highlightColor:
                                                          Colors.pink.shade100,
                                                      splashColor:
                                                          Colors.pink.shade100,
                                                      onPressed: () async {
                                                        if (toggleFav == false)
                                                          await ds.addtoFav(
                                                              productData['id']
                                                                  .toString());
                                                        else
                                                          await ds.removeFromFav(
                                                              productData['id']
                                                                  .toString());
                                                        setState(() {
                                                          toggleFav =
                                                              !toggleFav;
                                                        });
                                                      },
                                                      icon: Icon(
                                                          toggleFav
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: Colors.red)),
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
