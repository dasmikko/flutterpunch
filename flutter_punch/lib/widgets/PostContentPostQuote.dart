import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';

class PostContentPostqote extends StatelessWidget {
  final PostContentModel postContent;

  PostContentPostqote({@required this.postContent});

  @override
  Widget build(BuildContext context) {
    PostContentPostquoteOptionsModel pOptions = postContent.options;

    return Container(
      color: Colors.blue,
      child: Column(
        children: <Widget>[Text('PostQuote'), Text(pOptions.text)],
      ),
    );
  }
}
