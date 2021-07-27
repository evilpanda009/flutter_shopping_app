import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/utils/loading.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/authenticate.dart';
import 'package:shopping_app/home.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<User?>();
//     final DateTime start = DateTime.now();
//     final DateTime end = start.add(const Duration(seconds: 2));
//     print(user);
//     return TimerBuilder.scheduled([start, end], builder: (context) {
//       final bool ended = DateTime.now().compareTo(end) >= 0;
//       return ended
//           ? (user != null
//               ? GestureDetector(
//                   onTap: () {
//                     FocusScopeNode currentFocus = FocusScope.of(context);
//                     //if (!currentFocus.hasPrimaryFocus)
//                     currentFocus.unfocus();
//                   },
//                   child: Home(),

//                   // StreamBuilder(
//                   //     stream: FirebaseAuth.instance.authStateChanges(),
//                   //     builder: (context, snapshot) {
//                   //       if (!snapshot.hasData) return Text("Loading");
//                   //       return Authenticate();
//                   //     }),
//                 )
//               : GestureDetector(
//                   onTap: () {
//                     FocusScopeNode currentFocus = FocusScope.of(context);
//                     //if (!currentFocus.hasPrimaryFocus)
//                     currentFocus.unfocus();
//                   },
//                   child: Authenticate()))
//           : Splash();
//     });
//   }
// }

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start = DateTime.now();
    end = start.add(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return TimerBuilder.scheduled([start, end], builder: (context) {
      final bool ended = (DateTime.now().compareTo(end) >= 0);
      return ended
          ? (user != null
              ? GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    //if (!currentFocus.hasPrimaryFocus)
                    currentFocus.unfocus();
                  },
                  child: Home(),

                  // StreamBuilder(
                  //     stream: FirebaseAuth.instance.authStateChanges(),
                  //     builder: (context, snapshot) {
                  //       if (!snapshot.hasData) return Text("Loading");
                  //       return Authenticate();
                  //     }),
                )
              : GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    //if (!currentFocus.hasPrimaryFocus)
                    currentFocus.unfocus();
                  },
                  child: Authenticate()))
          : Loading();
    });
  }
}
   

// class Wrapper extends StatefulWidget {
//   const Wrapper({Key? key}) : super(key: key);

//   @override
//   _WrapperState createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> {
//   @override
//   bool isAuth = false;
//   bool isLoading = true;
//   void initState() {
//     super.initState();
//     final user = context.watch<User?>();
//     print(user);
//     if (user != null) {
//       isAuth = true;
//       isLoading = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? (isAuth
//             ? GestureDetector(
//                 onTap: () {
//                   FocusScopeNode currentFocus = FocusScope.of(context);
//                   //if (!currentFocus.hasPrimaryFocus)
//                   currentFocus.unfocus();
//                 },
//                 child: Home(),

//                 // StreamBuilder(
//                 //     stream: FirebaseAuth.instance.authStateChanges(),
//                 //     builder: (context, snapshot) {
//                 //       if (!snapshot.hasData) return Text("Loading");
//                 //       return Authenticate();
//                 //     }),
//               )
//             : GestureDetector(
//                 onTap: () {
//                   FocusScopeNode currentFocus = FocusScope.of(context);
//                   //if (!currentFocus.hasPrimaryFocus)
//                   currentFocus.unfocus();
//                 },
//                 child: Authenticate()))
//         : SafeArea(
//             child: Lottie.asset(
//               'assets/lottie_file.json',
//               repeat: true,
//               reverse: true,
//               animate: true,
//             ),
//           );
//   }
// }
// class SplashScreen extends StatefulWidget {
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     initializeUser();
//     navigateUser();
//   }

//   Future initializeUser() async {
//     // get User authentication status here
//   }
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final user = context.watch<User?>();
//     print(user);
//     if (user != null) {
//       // &&  FirebaseAuth.instance.currentUser.reload() != null
//       Timer(
//         Duration(seconds: 3),
//         () => Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => Home()),
//             (Route<dynamic> route) => false),
//       );
//     } else {
//       Timer(Duration(seconds: 4),
//           () => Navigator.pushReplacementNamed(context, "/SignIn"));
//     }
//   }

//   navigateUser() async {
//     // checking whether user already loggedIn or not
//     didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<User?>();
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           body: Center(
//         child: Lottie.asset(
//           'assets/data.json',
//           repeat: true,
//           animate: true,
//         ),
//       )),
//     );
//   }
// }
