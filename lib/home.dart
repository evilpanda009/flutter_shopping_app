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

  final tabs = [
    Profile(),
    Sell(),
    Market(),
    Cart(),
    Favorites(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: bgcolor,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: bgcolor,
              color: navbar,
              buttonBackgroundColor: navbar,
              animationDuration: Duration(milliseconds: 300),
              height: 55,
              index: 2,
              items: <Widget>[
                Icon(
                  Icons.person,
                ),
                Icon(Icons.sell),
                Icon(Icons.shopping_bag_outlined),
                Icon(Icons.shopping_cart),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              ],
              onTap: (index) {
                setState(() {
                  pageNumber = index;
                });
              },
            ),
            body: tabs[pageNumber]));
  }
}
