import 'package:flutter/material.dart';
import 'package:flutter_punch/screens/home.dart';
import 'package:flutter_punch/screens/forum.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/scopedModels/DrawerModel.dart';
import 'package:flutter_punch/themes/DefaultTheme.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Widget rv;

  SharedPreferences.getInstance().then((prefs) {
    prefs.setBool('showNSFWThreads', prefs.getBool('showNSFWThreads') != null ? prefs.getBool('showNSFWThreads') : false);
  });

   
  
  rv = new DynamicTheme(
    defaultBrightness: Brightness.dark,
    data: (brightness) => ThemeData(
      primarySwatch: Colors.red,
      brightness: brightness,
      accentColor: Colors.red
    ),
    themedWidgetBuilder: (context, theme) {
      return MaterialApp(
        title: 'Flutter punch',
        theme: theme,
        home: Home()
      );
    });

  rv = ScopedModel<DrawerModel>(model: DrawerModel(), child: rv);

  runApp(rv);
}

