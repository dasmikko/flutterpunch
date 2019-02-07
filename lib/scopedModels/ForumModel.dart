import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'dart:convert';
import 'dart:async';

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
    notifyListeners();
  }

  void updateLoadingState(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  Future<Null> getForum(String url) async {
    await APIHelper().fetchForum(url).then((data) {
      _threadList = data;

      // Then notify all the listeners.
      notifyListeners();

      return null;
    });
  }
}