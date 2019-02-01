import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:youtube_player/youtube_player.dart';

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
    } else if (options.contentType == "youtube") {
      return Container(
        child: Column(
          children: <Widget>[
            YoutubePlayer(
              source: options.url,
              quality: YoutubeQuality.HD,
              aspectRatio: 16 / 9,
              showThumbnail: true,
              autoInitialize: false,
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Text(postContent.type),
            Text(options.contentType != null ? options.contentType : "Unknown"),
          ],
        ),
      );
    }
  }
}
