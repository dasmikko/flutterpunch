import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';

class PostContentHotlink extends StatelessWidget {
  final PostContentModel postContent;

  PostContentHotlink({@required this.postContent});

  @override
  Widget build(BuildContext context) {
    PostContentHotlinkOptionsModel options = postContent.options;

    if (options.force != null && options.force == "image") {
      return Container(
        child: Column(
          children: <Widget>[
            Image(image: NetworkImage(options.url),)
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Text(postContent.type)
          ],
        ),
      );
    }
  }
}
