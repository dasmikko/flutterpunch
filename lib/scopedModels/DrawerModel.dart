import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_punch/helpers/API.dart';

class DrawerModel extends Model {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn; 

  bool _hasFetchedUser = false;
  bool get hasFetchedUser => _hasFetchedUser;

  int _alertsCount = 0;
  int get alertsCount => _alertsCount;

  String _username = "";
  String _avatar = "";
  int _level = 0;
  String _backgroundImage = "";

  String get username => _username;
  String get avatar => _avatar;
  int get level => _level;
  String get backgroundImage => _backgroundImage;

  void updateLoginState() async {
    print('Update login State');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') != null ? prefs.getBool('isLoggedIn') : false;

    if (!_hasFetchedUser) {
      getCurrentUser();
    }

    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('cookieString', "");
    _isLoggedIn = false;

    updateLoginState();
  }

  void getCurrentUser() {
    APIHelper().fetchCurrentUserInfo().then((userinfo) {
      _hasFetchedUser = true;
      _username = userinfo.username;
      _avatar = userinfo.avatar;
      _level = userinfo.level;
      _backgroundImage = userinfo.backgroundImage;
      notifyListeners();
    });
  }

  void updateAlertCount() {
    APIHelper().getAlerts().then((alertObj) {
      _alertsCount = alertObj.count;

      notifyListeners();
    });
  }

  static DrawerModel of(BuildContext context) =>
      ScopedModel.of<DrawerModel>(context, rebuildOnChange: true);
}