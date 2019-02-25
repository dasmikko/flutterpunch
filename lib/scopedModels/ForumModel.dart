import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ForumModelScoped extends Model {
  ThreadListModel _threadList =
      new ThreadListModel(threads: new List<ThreadModel>());

  int _pageNumber = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int get pageNumber => _pageNumber; 
  ThreadListModel get thread => _threadList;

  void updatePageNumber(int newPagenumber) {
    _pageNumber = newPagenumber;
  }

  void updateLoadingState(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  Future<Null> getForum(String url) async {
    await APIHelper().fetchForum(url).then((data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      ThreadListModel threadData = new ThreadListModel(threads: new List<ThreadModel>());

      if (!prefs.getBool('showNSFWThreads')) {
        threadData = new ThreadListModel(
          threads: data.threads.where((item) => !item.title.contains('Hottest Illustrated Girls')).toList(),
          currentPage: data.currentPage,
          totalPages: data.totalPages
        );
      } else {
        threadData = new ThreadListModel(
          threads: data.threads,
          currentPage: data.currentPage,
          totalPages: data.totalPages
        );
      }


      _threadList = threadData;

      // Then notify all the listeners.
      notifyListeners();

      return null;
    });
  }
}