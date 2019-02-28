import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_punch/screens/imageViewer.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_punch/helpers/Download.dart';
import 'package:path/path.dart';

class ImageWidget extends StatefulWidget {
  String url;
  GlobalKey<ScaffoldState> scaffoldKey;

  ImageWidget({this.url, this.scaffoldKey});
  

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {

  void imageLongPress(BuildContext context, String url) async {
    String fileName = basename(url);
    
    switch (await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(fileName),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, 1); },
              child: const Text('Copy image link'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, 2); },
              child: const Text('Download image'),
            ),
          ],
        );
      }
    )) {
      case 1:
        Clipboard.setData(new ClipboardData(text: url));
        this.widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text('Image link copied to clipboard'),
        ));
      break;
      case 2:
         DownloadHelper().downloadFile(url, this.widget.scaffoldKey);  
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onLongPress: () => this.imageLongPress(context, this.widget.url),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ImageViewerScreen(url: this.widget.url)),
            );
          },
          child: Container(
            height: 200,
            margin: EdgeInsets.only(bottom: 8.0),
            child: Hero(
              tag: this.widget.url,
              child: TransitionToImage(
                  image: AdvancedNetworkImage(this.widget.url,
                      useDiskCache: true)),
            ),
          ),
        );
  }
}