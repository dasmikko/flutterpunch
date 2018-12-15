import 'package:flutter_punch/models/ThreadModel.dart';

class ThreadListModel {
  final List<ThreadModel> threads;
  ThreadListModel({this.threads});

  factory ThreadListModel.fromJson(List<dynamic> parsedJson) {
    List<ThreadModel> threads = parsedJson.map((i)=> ThreadModel.fromJson(i)).toList();

    return new ThreadListModel(
       threads: threads,
    );
  }
}