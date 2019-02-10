import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'dart:async';

class PostListSM extends Model {
  PostListModel _postList = new PostListModel(posts: new List<PostModel>());
  int _pageNumber = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int get pageNumber => _pageNumber; 
  PostListModel get posts => _postList;

  void updatePageNumber(int newPagenumber) {
    _pageNumber = newPagenumber;
  }

  void updateLoadingState(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  Future<Null> getPosts(String url) async {
    print("Gettings posts");

    await APIHelper().fetchThread(url).then((data) {
      _postList = data;

      // Then notify all the listeners.
      notifyListeners();

      return null;
    });
  }
}