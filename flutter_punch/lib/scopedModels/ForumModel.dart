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

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  ThreadListModel get thread => _threadList;

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