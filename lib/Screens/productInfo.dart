import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    print("hoooray");
    print(ds.cart);
    print(ds.fav);
    return null;
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
            backgroundColor: Colors.greenAccent,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Hero(
                            tag: "product" + index.toString(),
                            child: Image.network(productData['image']),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text(productData['title'])),
                  Center(child: Text(productData['desc'])),
                  Center(child: Text(productData['category'])),
                  Center(child: Text('\$ ' + productData['price'].toString())),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (toggleCart == false)
                              await ds.addtoCart(productData['id'].toString());
                            else
                              await ds
                                  .removeFromCart(productData['id'].toString());
                            setState(() {
                              toggleCart = !toggleCart;
                            });
                          },
                          child: Text(
                              toggleCart ? 'Remove from Cart' : 'Add to Cart')),
                      IconButton(
                          onPressed: () async {
                            if (toggleFav == false)
                              await ds.addtoFav(productData['id'].toString());
                            else
                              await ds
                                  .removeFromFav(productData['id'].toString());
                            setState(() {
                              toggleFav = !toggleFav;
                            });
                          },
                          icon: Icon(toggleFav
                              ? Icons.favorite
                              : Icons.favorite_border)),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
