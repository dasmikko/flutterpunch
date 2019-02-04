import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/CategoryModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'dart:convert';
import 'dart:async';

class CategoryModelScoped extends Model {
  CategoryListModel _categoryList =
      new CategoryListModel(categories: new List<CategoryModel>());

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  CategoryListModel get categories => _categoryList;

  void updateLoadingState(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  Future<Null> getCategories() async {
    await APIHelper().fetchCategories().then((data) {
      _categoryList = data;

      // Then notify all the listeners.
      notifyListeners();

      return null;
    });
  }
}