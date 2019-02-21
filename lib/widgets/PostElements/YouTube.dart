import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class YouTubeEmbed extends StatelessWidget {
  String url;

  YouTubeEmbed({@required this.url});

  void playYouTubeVideo(String url) {
    FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: "AIzaSyBehHEbtDN5ExcdWydEBp5R8EYlB6cf6nM",
        videoUrl: url,
        autoPlay: true, //default falase
        fullScreen: false //default false
        );
  }

  @override
  Widget build(BuildContext context) {
    var id = Uri.parse(this.url).queryParameters['v'];

    if (id == null) {
      id = this.url.split("/").last;
    }

    print(id);
    print(Uri.parse(this.url));

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: Stack(
          alignment: Alignment(0, 0),
          children: <Widget>[
            TransitionToImage(
              image: AdvancedNetworkImage(
                  "https://img.youtube.com/vi/${id}/maxresdefault.jpg"),
              placeholder: CircularProgressIndicator(),
            ),
            Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 124.0,
            ),
            new Positioned.fill(
              child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  onTap: () => playYouTubeVideo(this.url),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
