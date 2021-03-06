import 'package:http/http.dart' as http;
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/CurrentUserModel.dart';
import 'package:flutter_punch/models/AlertsModel.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

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

  Future<bool> ratePost(int postId, int ratingId) async {
    print('Rating post');
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FormData formData = new FormData.from({
      "postid": postId,
      "ratingid": ratingId,
    });

    Response response;
    Dio dio = Dio();
    dio.options.headers = {
      'Origin': 'https://forum.facepunch.com',
      'Cookie': prefs.getString('cookieString')
    };

    response = await dio.post('https://forum.facepunch.com/vote/post/', data: formData);   
    
    if (response.statusCode == 200) {
      print('rated!');

      print(response.data);
      // If server returns an OK response, parse the JSON
      return true;
    } else {
      // If that response was not OK, throw an error.
      throw Exception("Failed to rate");
    }
  }

  Future<AlertsModel> getAlerts() async {
    print('Getting alerts');
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;
    Dio dio = Dio();
    dio.options.headers = {
      'Origin': 'https://forum.facepunch.com',
      'Cookie': prefs.getString('cookieString')
    };

    response = await dio.post('https://forum.facepunch.com/forumuser/alerts/');   
    
    if (response.statusCode == 200) {
      print('Got alerts');
      // If server returns an OK response, parse the JSON
      return AlertsModel.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception("Failed to rate");
    }
  }
  
}
