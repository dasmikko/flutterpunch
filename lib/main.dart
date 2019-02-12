import 'package:flutter/material.dart';
import 'package:flutter_punch/screens/home.dart';
import 'package:flutter_punch/screens/forum.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/scopedModels/DrawerModel.dart';

void main() {
  Widget rv;

  rv = MaterialApp(
    title: 'Flutter punch',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: Home()
  );

  rv = ScopedModel<DrawerModel>(model: DrawerModel(), child: rv);

  runApp(rv);
}

