import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/utils/api.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:shopping_app/utils/product.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var data;
  final String url = 'https://fakestoreapi.com/products';
  bool loading = true;
  var tempImage = new AssetImage('assets/loading1.jpg');
  bool toggleCart = false;
  bool toggleFav = false;
  DatabaseService ds = DatabaseService();
  bool notFound = false;

  final _random = new Random();
  void getData() async {
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        loading = false;
        data = jsonDecode(res.body);
        //print(res.body);
        print(data);
      });
    } else {
      setState(() {
        loading = false;
        notFound = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  ScrollController controller = new ScrollController();
  late AnimationController _animationController;
  late Animation _animation;
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('products')
      .orderBy('id')
      .snapshots();
  final String id = AuthService().getUser().toString();
  late String name;

  getUserName() async {
    var user = AuthService().getUser().toString();

    await FirebaseFirestore.instance
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
          //email = data['email'].toString();
          //loading = false;
        });
      }
    });
  }

  final txtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //getData();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .orderBy('id')
      .snapshots();

  final Stream<QuerySnapshot> productStream1 = FirebaseFirestore.instance
      .collection('products')
      .orderBy('price', descending: false)
      .snapshots();

  final Stream<QuerySnapshot> productStream2 = FirebaseFirestore.instance
      .collection('products')
      .orderBy('price', descending: true)
      .snapshots();

  final Stream<QuerySnapshot> productStream3 = FirebaseFirestore.instance
      .collection('products')
      .orderBy('title', descending: false)
      .snapshots();

  void handleClick(String value) {
    switch (value) {
      case 'Price Ascending':
        setState(() {
          stream = productStream1;
        });
        break;
      case 'Price Descending':
        setState(() {
          stream = productStream2;
        });
        break;
      case 'Alphabetical':
        setState(() {
          stream = productStream3;
        });
        break;
    }
  }

  void categories(String value) {
    final String query = value;
    if (query == "All") {
      setState(() {
        stream = productStream;
      });
    } else {
      setState(() {
        stream = FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: "$query")
            .snapshots();
      });
    }
  }

  void search(String searchkey) {
    if (searchkey.trim() == "" || searchkey.isEmpty) {
      setState(() {
        stream = productStream;
      });
    } else {
      setState(() {
        stream = FirebaseFirestore.instance
            .collection('products')
            .orderBy('title')
            .where('title', isGreaterThanOrEqualTo: searchkey)
            .where('title', isLessThan: searchkey + 'z')
            .snapshots();
      });
    }
  }

  List? cart = [];
  List? fav = [];
  List? quantity = [];
  // _navigateAndDisplaySelection(BuildContext context, index) async {
  //   // Navigator.push returns a Future that completes after calling
  //   // Navigator.pop on the Selection Screen.
  //   final int result =
  //       await Navigator.pushNamed(context, '/product', arguments: data[index])
  //           as int;
  //   print(result.toString());
  //   // controller.animateTo(double.parse(result.toString()),
  //   //     duration: Duration(seconds: 1), curve: Curves.ease);
  //   //controller.jumpTo(controller.position.maxScrollExtent);
  //   // ScaffoldMessenger.of(context)
  //   //     .showSnackBar(SnackBar(content: Text("Product ID $result")));
  // }

  //Response res = await get(Uri.parse(url));

  //await addProducts(jsonDecode(res.body));
  //final Stream<QuerySnapshot>  getUserData = FirebaseFirestore.instance.collection('users').where('id',isEqualTo: id).snapshots();

  // if (cart == null) cart = [];
  // if (fav == null) fav = [];

  final LinearGradient myGradient = LinearGradient(
    colors: <Color>[Colors.orange[100]!, Colors.pink[100]!],
  );
  late Map<String, dynamic> userdata;

  final List categoryList = <String>[
    "All",
    r"Men's Clothing",
    r"Women's Clothing",
    r"Kid's Stuff",
    r"Electronics",
    r"Home Accessories",
    r"Women's Accessories",
    r"Men's Accessories",
    r"Miscellaneous"
  ];
  Color filledcolor = Colors.grey[200]!;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // id = AuthService().getUser().toString();
    return
        // : Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: ListView.builder(
        //         itemCount: data == null ? 0 : data.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return Center(
        //             child: Container(
        //               margin: EdgeInsets.all(20),
        //               padding: EdgeInsets.all(20),
        //               color: Colors.orange,
        //               child: Text(data[index]['id'].toString()),
        //             ),
        //           );
        //         }),
        //   );
        StreamBuilder<DocumentSnapshot>(
            // future: FirebaseFirestore.instance .collection('users').doc(id).get(),
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorGif();
              }
              if (snapshot.hasData && snapshot.data != null) {
                userdata = snapshot.data!.data() as Map<String, dynamic>;
                name = userdata['name'];
                return Scaffold(
                    drawer: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10)),
                      child: Drawer(
                          child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Container(
                                  decoration: BoxDecoration(
                                    gradient: myGradient,
                                    // borderRadius: BorderRadius.only(
                                    //     bottomLeft: Radius.circular(15),
                                    //     bottomRight: Radius.circular(15))
                                  ),
                                  //color: Colors.red,

                                  height: 200,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 30),
                                    child: Text("Hi,\n$name",
                                        maxLines: 3,
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                        style: GoogleFonts.montserrat(
                                            height: 1.7,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1)),
                                  )),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.sell_rounded,
                                              size: 14),
                                        ),
                                        TextSpan(
                                          text: " Categories",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemCount: categoryList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            categories(
                                                categoryList[index].toString());
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            categoryList[index].toString(),
                                            style: GoogleFonts.montserrat(),
                                          )),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )),
                    ),
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: Text(
                        "Shop",
                        style: GoogleFonts.montserrat(
                            foreground: Paint()..shader = txtgradient1,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {
                              'Price Ascending',
                              'Price Descending',
                              'Alphabetical'
                            }.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    body: StreamBuilder<QuerySnapshot>(
                        stream: stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.deepOrange,
                            ));
                          }

                          if (snapshot.hasError) {
                            return ErrorGif();
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            data = snapshot.data!.docs;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        //color: Colors.grey,
                                        gradient: myGradient,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: txtController,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Search", //\u1d5d\u1d49\u1d57\u1d43 ",
                                        alignLabelWithHint: true,
                                        suffix: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            txtController.text = "";
                                            search("");
                                          },
                                        ),
                                        //filled: true,
                                        //fillColor: Colors.white,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(top: 25),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide.none,
                                        ),
                                        //   (
                                        //       color: Colors.orange, width: 1.5),
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.5),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        search(value.trim());
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // ClipOval(
                                //     child: Container(
                                //   height: 50,
                                //   width: MediaQuery.of(context).size.width,
                                //   color: Colors.red,
                                // )),
                                Expanded(
                                  child: StaggeredGridView.countBuilder(
                                      key: PageStorageKey("List"),
                                      physics: BouncingScrollPhysics(),
                                      controller: controller,
                                      crossAxisCount:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? 2
                                              : 3,
                                      crossAxisSpacing: 3,
                                      mainAxisSpacing: 3,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            // await _navigateAndDisplaySelection(
                                            //     context, index);
                                            //print(index);
                                            Navigator.pushNamed(
                                                context, '/product',
                                                arguments: data[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        blurRadius: 3,
                                                        spreadRadius: 1,
                                                        offset: Offset(0, 3))
                                                  ],
                                                  color:
                                                      Colors.white, //colList[
                                                  //     _random.nextInt(colList.length)],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Hero(
                                                        tag: "product" +
                                                            index.toString(),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 150,
                                                          placeholder:
                                                              'assets/loading2.gif',
                                                          image: data[index]
                                                              ['image'],
                                                          imageErrorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/no-internet.gif',
                                                              height: 150,
                                                              fit: BoxFit
                                                                  .contain,
                                                            );
                                                          },
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FractionallySizedBox(
                                                    widthFactor: 0.9,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                              '\$' +
                                                                  data[index][
                                                                          'price']
                                                                      .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              softWrap: false,
                                                            ),
                                                          ),
                                                        ),
                                                        // IconButton(
                                                        //     onPressed: () {
                                                        //       setState(() {
                                                        //         toggleCart =
                                                        //             !toggleCart;
                                                        //         if (toggleCart ==
                                                        //             true)
                                                        //           ds.addtoCart(data[
                                                        //                       index]
                                                        //                   ['id']
                                                        //               .toString());
                                                        //         else
                                                        //           ds.removeFromCart(
                                                        //               data[index][
                                                        //                       'id']
                                                        //                   .toString());
                                                        //       });
                                                        //     },
                                                        //     icon: Icon(
                                                        //         userdata['cart'].contains(
                                                        //                 data[index]
                                                        //                         [
                                                        //                         'id']
                                                        //                     .toString())
                                                        //             ? Icons
                                                        //                 .shopping_cart
                                                        //             : Icons
                                                        //                 .shopping_cart_outlined,
                                                        //         size: 15)),
                                                        IconButton(
                                                            onPressed: () {
                                                              int i = index;
                                                              setState(() {
                                                                toggleFav =
                                                                    !toggleFav;
                                                                if (!userdata[
                                                                        'fav']
                                                                    .contains(data[index]
                                                                            [
                                                                            'id']
                                                                        .toString()))
                                                                  ds.addtoFav(data[
                                                                              index]
                                                                          ['id']
                                                                      .toString());
                                                                else
                                                                  ds.removeFromFav(
                                                                      data[index]
                                                                              [
                                                                              'id']
                                                                          .toString());
                                                                controller.animateTo(
                                                                    i /
                                                                        (data
                                                                            .length) *
                                                                        controller
                                                                            .position
                                                                            .maxScrollExtent,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .ease);
                                                              });
                                                            },
                                                            icon: Icon(
                                                              userdata['fav'].contains(
                                                                      data[index]
                                                                              [
                                                                              'id']
                                                                          .toString())
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: 20,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0,
                                                            left: 15,
                                                            right: 10),
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: Text(
                                                        data[index]['title'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      staggeredTileBuilder: (index) {
                                        return StaggeredTile.fit(1);
                                      }),
                                ),
                              ]),
                            );
                          }

                          return Empty();
                        }));
              }
              return Empty();
            });
  }
}
