import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter/services.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;

  ImageViewerScreen({@required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image viewer"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              print("download");
            },
          ),
        ],
      ),
      body: Container(
        child: Hero(
          tag: this.url,
          child: ZoomableWidget(
            minScale: 1.0,
            maxScale: 2.0,
            zoomSteps: 3,
            enableFling: true,
            autoCenter: true,
            multiFingersPan: false,
            bounceBackBoundary: true,
            // default factor is 1.0, use 0.0 to disable boundary
            panLimit: 1.0,
            child: Image(
              image: AdvancedNetworkImage(this.url, useDiskCache: true),
            ),
          ),
        ),
      ),
    );
  }
}
