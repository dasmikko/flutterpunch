import 'package:flutter_punch/models/ThreadModel.dart';

class ThreadListModel {
  final int currentPage;
  final int totalPages;
  final List<ThreadModel> threads;
  ThreadListModel({this.threads, this.currentPage, this.totalPages});

  factory ThreadListModel.fromJson(Map<String, dynamic> parsedJson) {
     var threadsList = parsedJson['threads'] as List;

    List<ThreadModel> threads = threadsList.map((i)=> ThreadModel.fromJson(i)).toList();

    return new ThreadListModel(
      currentPage: parsedJson['currentPage'],
      totalPages: parsedJson['totalPages'],
      threads: threads,
    );
  }
}