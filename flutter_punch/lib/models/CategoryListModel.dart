import 'package:flutter_punch/models/CategoryModel.dart';

class CategoryListModel {

  final List<CategoryModel> categories;

  CategoryListModel({this.categories});

  factory CategoryListModel.fromJson(List<dynamic> parsedJson) {

    List<CategoryModel> categories = parsedJson.map((i)=> CategoryModel.fromJson(i)).toList();

    return new CategoryListModel(
       categories: categories,
    );
  }
}