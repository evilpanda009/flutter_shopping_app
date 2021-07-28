import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xfff3f0ec),
        child: Center(
          child: Image.asset(
            'assets/load.gif',
            height: 300,
            width: 320,
          ),
          // child: SpinKitChasingDots(
          //   color: Colors.blue,
          //   size: 50,
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xfff3f0ec),
        child: Image.asset(
          'assets/flame1.gif',
          height: 120,
          width: 120,
        ),
      ),
    );
  }
}

class ErrorGif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xfff3f0ec),
        child: Image.asset(
          'assets/no_connection.gif',
          height: 120,
          width: 120,
        ),
      ),
    );
  }
}
