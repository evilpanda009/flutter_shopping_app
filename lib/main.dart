import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Screens/cart.dart';
import 'package:shopping_app/Screens/cartHistory.dart';
import 'package:shopping_app/Screens/editProduct.dart';
import 'package:shopping_app/Screens/favorites.dart';
import 'package:shopping_app/Screens/market.dart';
import 'package:shopping_app/Screens/productInfo.dart';
import 'package:shopping_app/Screens/sell.dart';
import 'package:shopping_app/Screens/profile.dart';
import 'package:shopping_app/Screens/sellProduct.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/home.dart';
import 'package:shopping_app/register.dart';
import 'package:shopping_app/signIn.dart';
import 'package:shopping_app/utils/auth.dart';
import 'package:shopping_app/wrapper.dart';

import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     systemNavigationBarColor: const Color(0xFF0094d4), // navigation bar color
  //     statusBarColor: const Color(0xFF0094d4) // status bar color 0xFF0094d4
  //     ));
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/cart.jpg"), context);
    precacheImage(AssetImage("assets/google.jpg"), context);
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(
            create: (context) => context.read<AuthService>().userState,
            initialData: null)
      ],
      child: MaterialApp(
        routes: {
          '/auth': (context) => Authenticate(),
          '/register': (context) => Register(),
          '/SignIn': (context) => SignIn(),
          '/home': (context) => Home(),
          '/cart': (context) => Cart(),
          '/favorites': (context) => Favorites(),
          '/sell': (context) => Sell(),
          '/profile': (context) => Profile(),
          '/product': (context) => ProductInfo(),
          '/sellItem': (context) => SellItem(),
          '/history': (context) => CartHistory(),
          '/edit': (context) => EditProduct(),
        },
        home: Wrapper(),
      ),
    );
  }
}
