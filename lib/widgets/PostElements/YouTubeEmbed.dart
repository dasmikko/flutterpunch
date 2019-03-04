import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class YoutubeVideoEmbed extends StatefulWidget {
  final String url;

  YoutubeVideoEmbed({this.url});

  @override
  _YoutubeEmbedState createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<YoutubeVideoEmbed> {
  String maxResThumbnail;
  String sdResThumbnail;
  String defaultThumbnail;
  String res;

  @override
  void initState() {
    super.initState();

    var id = Uri.parse(this.widget.url).queryParameters['v'];

    if (id == null) {
      id = this.widget.url.split("/").last;
    }

    this.maxResThumbnail = "https://img.youtube.com/vi/${id}/maxresdefault.jpg";
    this.sdResThumbnail = "https://img.youtube.com/vi/${id}/sddefault.jpg";
    this.defaultThumbnail = "https://img.youtube.com/vi/${id}/default.jpg";
    this.res = 'max';
  }

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
    print("Res: ${this.res}");
    print(this.widget.url);
    

    String thumbnailUrl = "UNKOWN";

    switch (res) {
      case 'max':
        thumbnailUrl = maxResThumbnail;
        break;
      case 'sd':
        thumbnailUrl = sdResThumbnail;
        break;
      case 'default':
        thumbnailUrl = defaultThumbnail;
        break;
    }

    print(thumbnailUrl);
    
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
                  thumbnailUrl,
                  retryLimit: 0,
                  timeoutDuration: Duration(seconds: 5),
                  loadFailedCallback: () {
                    print('Load failed, change res');
                    setState(() {
                      switch (res) {
                        case 'max':
                          this.res = 'sd';
                          break;
                        case 'sd':
                          this.res = 'default';
                          break;
                      }
                    });
                  }),
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
                  onTap: () => playYouTubeVideo(this.widget.url),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
