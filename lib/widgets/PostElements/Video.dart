import "package:flutter/material.dart";
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoElement extends StatefulWidget {
  String url;

  VideoElement(@required this.url);

  @override
  _VideoElementState createState() => _VideoElementState();
}

class _VideoElementState extends State<VideoElement> {
  VideoPlayerController vidController;
  ChewieController chewieController;
  Size size = new Size(16, 9);

  @override
  void initState() {
    super.initState();

    vidController = VideoPlayerController.network(widget.url);

    vidController
      ..initialize().then((onValue) {
        print(vidController.value.size);
        setState(() {
          size = vidController.value.size;

          chewieController = ChewieController(
              videoPlayerController: vidController,
              aspectRatio: size.width / size.height,
              autoInitialize: false,
              looping: true,
              autoPlay: false);
        });
      });

    chewieController = ChewieController(
        videoPlayerController: vidController,
        aspectRatio: size.width / size.height,
        autoInitialize: false,
        looping: true,
        autoPlay: false);
  }

  @override
  void dispose() {
    vidController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}
