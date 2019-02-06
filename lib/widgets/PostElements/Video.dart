import "package:flutter/material.dart";
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';



class VideoElement extends StatefulWidget {
  String url;
  VideoPlayerController vidController = null;
  ChewieController chewieController = null;

  VideoElement(@required this.url) {
    this.vidController = VideoPlayerController.network(this.url);
    this.chewieController = ChewieController(
            videoPlayerController: vidController,
            aspectRatio: 16 / 9,
            autoInitialize: true,
            looping: true,
            autoPlay: false
          );
  }
  

  @override
  _VideoElementState createState() => _VideoElementState();
}

class _VideoElementState extends State<VideoElement> {

  @override
  void dispose() {
    widget.vidController.dispose();
    widget.chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Chewie(
          controller: widget.chewieController,
        ),
    );
  }
}