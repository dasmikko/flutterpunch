import 'package:flutter/material.dart';
import 'package:flutter_punch/screens/home.dart';
import 'package:flutter_punch/screens/forum.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter punch',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: Home()
  ));
}

