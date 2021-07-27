import 'dart:convert';
import 'dart:math';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_app/utils/database.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:shopping_app/utils/product.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> with SingleTickerProviderStateMixin {
  var data;
  final String url = 'https://fakestoreapi.com/products';
  bool loading = true;
  var tempImage = new AssetImage('assets/google.jpg');
  bool toggleCart = false;
  bool toggleFav = false;
  DatabaseService ds = DatabaseService();
  bool notFound = false;

  List<Color> colList = [
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.purple,
    Colors.lightBlue
  ];
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

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    getData();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : notFound
            ? Splash()
            :
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
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Text(
                    "Marketplace",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
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
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.pushNamed(context, '/product',
                                  arguments: data[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                          offset: Offset(0, 3))
                                    ],
                                    color: colList[
                                        _random.nextInt(colList.length)],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Hero(
                                            tag: "product" + index.toString(),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: 'assets/google.jpg',
                                              image: data[index]['image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '\$' +
                                                  data[index]['price']
                                                      .toString(),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  toggleCart = !toggleCart;
                                                  if (toggleCart == true)
                                                    ds.addtoCart(data[index]
                                                            ['id']
                                                        .toString());
                                                  else
                                                    ds.removeFromCart(
                                                        data[index]['id']
                                                            .toString());
                                                });
                                              },
                                              icon: Icon(
                                                  toggleCart
                                                      ? Icons.shopping_cart
                                                      : Icons
                                                          .shopping_cart_outlined,
                                                  size: 15)),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  toggleFav = !toggleFav;
                                                });
                                              },
                                              icon: Icon(
                                                toggleFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 15,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, left: 10, right: 10),
                                      child: Center(
                                        child: Text(
                                          data[index]['title'],
                                          overflow: TextOverflow.ellipsis,
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

                  // child: GridView.builder(
                  //   itemCount: data.length,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: (MediaQuery.of(context).orientation ==
                  //             Orientation.portrait)
                  //         ? 2
                  //         : 3,
                  //     mainAxisSpacing: 10,
                  //   ),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return ClipRRect(
                  //       borderRadius: BorderRadius.circular(20),
                  //       child: new Card(
                  //         shape: RoundedRectangleBorder(
                  //           side: BorderSide(color: Colors.white70, width: 1),
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         child: new GridTile(
                  //           footer: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Text(
                  //               data[index]['title'].toString(),
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Image.network(
                  //                 data[index]['image'].toString()),
                  //           ), //just for testing, will fill with image later
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  //       new StaggeredGridView.count(
                  //         crossAxisCount: 4, // I only need two card horizontally
                  //         padding: const EdgeInsets.all(2.0),
                  //         children: data.map<Widget>((item) {
                  //           //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
                  //           return new Card(
                  //             semanticContainer: false,
                  //             shape: const RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Image.network(data['image']),
                  //                 Text(data['title']),
                  //                 Text(data['price']),
                  //               ],
                  //             ),
                  //           );
                  //         }).toList(),

                  //         //Here is the place that we are getting flexible/ dynamic card for various images
                  //         staggeredTiles: data
                  //             .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                  //             .toList(),
                  //         mainAxisSpacing: 3.0,
                  //         crossAxisSpacing: 4.0, // add some space
                  //       ),
                  //     ],
                  //   ),
                  // );
                ]),
              );
  }
}
