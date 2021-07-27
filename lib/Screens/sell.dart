import 'package:flutter/material.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.orange,
        child: Text('Sell'),
      ),
    );
  }
}
