import 'package:flutter_punch/models/PostModel.dart';

class PostListModel {
  final String threadName;
  final int currentPage;
  final int totalPages;
  final List<PostModel> posts;

  PostListModel(
      {this.threadName, this.currentPage, this.totalPages, this.posts});

  factory PostListModel.fromJson(Map<String, dynamic> parsedJson) {
    var postsList = parsedJson['posts'] as List;

    List<PostModel> posts =
        postsList.map((i) => PostModel.fromJson(i)).toList();

    return new PostListModel(
      threadName: parsedJson['threadName'],
      currentPage: parsedJson['currentPage'],
      totalPages: parsedJson['totalPages'],
      posts: posts,
    );
  }
}
