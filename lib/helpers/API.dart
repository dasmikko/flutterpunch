import 'package:http/http.dart' as http;
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/CurrentUserModel.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:shared_preferences/shared_preferences.dart';

class APIHelper {
  final baseURL = 'https://facepunch-api-eu.herokuapp.com/';

  Future<CategoryListModel> fetchCategories() async {
    print('Fetching categories');
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = null;

    if (prefs.getBool('isLoggedIn') != null && prefs.getBool('isLoggedIn')) {
      response = await http.get(baseURL, headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Cookie': prefs.getString('cookieString')
      });
    } else {
      response = await http.get(baseURL, headers: {'Content-type': 'application/json; charset=utf-8'});
    }
    
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return CategoryListModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ThreadListModel> fetchForum(String id) async {
    print('Fetching forum');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = null;

    if (prefs.getBool('isLoggedIn') != null && prefs.getBool('isLoggedIn')) {
      response = await http.get(baseURL + id, headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Cookie': prefs.getString('cookieString')
      });
    } else {
      response = await http.get(baseURL + id, headers: {'Content-type': 'application/json; charset=utf-8'});
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return ThreadListModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<PostListModel> fetchThread(String url) async {
    print('Fetching thread');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = null;

    if (prefs.getBool('isLoggedIn') != null && prefs.getBool('isLoggedIn')) {
      response = await http.get(baseURL + url.substring(1), headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Cookie': prefs.getString('cookieString')
      });
    } else {
      response = await http.get(baseURL + url.substring(1), headers: {'Content-type': 'application/json; charset=utf-8'});
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return PostListModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<CurrentUserModel> fetchCurrentUserInfo() async {
    print('Fetching currentUserInfo');
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = null;

    if (prefs.getBool('isLoggedIn') != null && prefs.getBool('isLoggedIn')) {
      response = await http.get(baseURL + 'currentUserInfo', headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Cookie': prefs.getString('cookieString')
      });
    } else {
      response = await http.get(baseURL + 'currentUserInfo', headers: {'Content-type': 'application/json; charset=utf-8'});
    }
    
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return CurrentUserModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
