import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class PostContentHotlink extends StatelessWidget {
  final PostContentModel postContent;

  PostContentHotlink({@required this.postContent});

  @override
  Widget build(BuildContext context) {
    PostContentHotlinkOptionsModel options = postContent.options;

    if (options.force != null &&
        (options.force == "image" || options.contentType == "image")) {
      return Container(
        child: Column(
          children: <Widget>[
            Image(
              image: AdvancedNetworkImage(options.url, useDiskCache: true),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Text(postContent.type),
          ],
        ),
      );
    }
  }
}
