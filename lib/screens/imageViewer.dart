import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter_punch/helpers/Download.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ImageViewerScreen({@required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: Text("Image viewer"),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              print("download");

              var scaffoldContext = context;
              DownloadHelper().downloadFile(url, _scaffoldKey);              
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
