import 'package:flutter_punch/models/ForumsModel.dart';

class CategoryModel {
  final String categoryName;
  final List<ForumsModel> forums;

  CategoryModel({
    this.categoryName,
    this.forums
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Parse forums too
    var list = json['forums'] as List;
    List<ForumsModel> forumsList = list.map((i) => ForumsModel.fromJson(i)).toList();

    return CategoryModel(
      categoryName: json['categoryName'],
      forums: forumsList
    );
  }
}