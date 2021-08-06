import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/Screens/favorites.dart';
import 'package:shopping_app/Screens/market.dart';
import 'package:shopping_app/Screens/profile.dart';
import 'package:shopping_app/Screens/sell.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageNumber = 2;
  Color bgcolor = Color(0xfff3f0ec);
  Color navbarbg = Color(0xfff3f0ec);
  Color navbar = Color(0xffBFDBF7);
  final Shader txtgradient1 = LinearGradient(
    colors: <Color>[Colors.orange[400]!, Colors.pink[300]!],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool first = false;
  var args;
  @override
  void initState() {
    super.initState();
    first = true;
  }

  final tabs = [
    Profile(),
    Sell(),
    Market(),
    Cart(),
    Favorites(),
  ];
  @override
  Widget build(BuildContext context) {
    args = null;
    if (first) {
      args = ModalRoute.of(context)!.settings.arguments ?? null;
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: bgcolor,
            bottomNavigationBar: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                gradient: LinearGradient(colors: [
                  Colors.orange[400]!,
                  Colors.pink[300]!
                ] //Color(0xFF00D0E1), Color(0xFF00B3FA)],
                    // begin: Alignment.topLeft,
                    // end: Alignment.topRight,
                    // stops: [0.0, 0.8],
                    // tileMode: TileMode.clamp,
                    ),
              ),
              child: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                color: Colors.white,
                buttonBackgroundColor: Colors.transparent,
                animationDuration: Duration(milliseconds: 300),
                height: 55,
                index: args ?? pageNumber,
                items: <Widget>[
                  Icon(
                    Icons.person,
                    //color: Colors.white,
                  ),
                  Icon(
                    Icons.sell,
                    //color: Colors.white,
                  ),
                  Icon(
                    Icons.shopping_bag_outlined,
                    //color: Colors.white,
                  ),
                  Icon(
                    Icons.shopping_cart,
                    //color: Colors.white,
                  ),
                  Icon(
                    Icons.favorite,
                    //color: Colors.white,
                  )
                ],
                onTap: (index) {
                  setState(() {
                    first = false;
                    args = null;
                    pageNumber = index;
                  });
                },
              ),
            ),
            body: args == null ? tabs[pageNumber] : tabs[args]));
  }
}
