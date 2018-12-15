import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ForumsModel.dart';

class ForumScreen extends StatelessWidget {
  final ForumsModel forum;

  ForumScreen({@required this.forum});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(forum.title),
      ),
      body: Text(forum.subtitle)
    );
  }
}