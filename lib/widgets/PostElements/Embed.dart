import 'package:flutter/material.dart';
import 'package:flutter_punch/scopedModels/UrlEmbedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class EmbedWidget extends StatefulWidget {
  String url;

  EmbedWidget(this.url);

  @override
  _EmbedWidgetState createState() => _EmbedWidgetState();
}

class _EmbedWidgetState extends State<EmbedWidget>
    with AutomaticKeepAliveClientMixin {
  String _title = "Fetching embed...";
  String _description = "";
  String _imageUrl;

  @override
  void initState () {
    super.initState();
    fetchHtml(widget.url);
  }

  void fetchHtml(url) {
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        var document = parse(response.body);

        var list = document.getElementsByTagName('meta');

        setState(() {
          for (var item in list) {
            if (item.attributes['property'] == "og:title") {
              _title = item.attributes['content'];
            }

            if (item.attributes['property'] == "og:description") {
              _description = item.attributes['content'];
            }

            if (item.attributes['property'] == "og:image") {
              _imageUrl = item.attributes['content'];
            }
          }
        });
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  bool notNull(Object o) => o != null;

  Widget handleImage(String url) {
    return TransitionToImage(
      image: AdvancedNetworkImage(url),
      placeholder: CircularProgressIndicator(),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //UrlEmbedModel.of(context).fetchHtml(this.url);
    return new Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(widget.url)) {
            await launch(widget.url);
          }
        },
        child: Column(
          children: <Widget>[
            _imageUrl != null ? handleImage(_imageUrl) : null,
            ListTile(
              title: Text(_title),
              subtitle: Text(_description),
            ),
          ].where(notNull).toList(),
        ),
      ),
    );
  }
}
