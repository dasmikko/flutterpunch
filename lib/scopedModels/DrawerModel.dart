import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/models/AlertsModel.dart';

class DrawerModel extends Model {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn; 

  bool _hasFetchedUser = false;
  bool get hasFetchedUser => _hasFetchedUser;

  int _alertsCount = 0;
  int get alertsCount => _alertsCount;

  List<SingleAlertModel> _alerts = List();
  List<SingleAlertModel> get alerts => _alerts;

  String _username = "";
  String _avatar = "";
  int _level = 0;
  String _backgroundImage = "";

  String get username => _username;
  String get avatar => _avatar;
  int get level => _level;
  String get backgroundImage => _backgroundImage;

  DrawerModel() {
    SharedPreferences.getInstance().then((prefs) {
      this._backgroundImage = prefs.getString('cachedBackgroundImage');
      this._username = prefs.getString('cachedUsername');
      this._avatar = prefs.getString('cachedAvatar');
      this._level = prefs.getInt('cachedLevel');
      notifyListeners();
    });
  }

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

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('cachedUsername', userinfo.username);
        prefs.setString('cachedAvatar', userinfo.avatar);
        prefs.setInt('cachedLevel', userinfo.level);
        prefs.setString('cachedBackgroundImage', userinfo.backgroundImage);
      });
      
      notifyListeners();
    });
  }

  void updateAlertCount() {
    APIHelper().getAlerts().then((alertObj) {
      _alertsCount = alertObj.count;
      _alerts = alertObj.alerts;

      notifyListeners();
    });
  }

  static DrawerModel of(BuildContext context) =>
      ScopedModel.of<DrawerModel>(context, rebuildOnChange: true);
}