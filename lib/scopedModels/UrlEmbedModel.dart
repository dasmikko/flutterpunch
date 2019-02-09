import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class UrlEmbedModel extends Model {
  String _title = "Fetching...";
  String _description = "Fetching still...";
  String _imageUrl;

  // Getters
  String get title => _title;
  String get description => _description; 
  String get imageUrl => _imageUrl;

  /// Wraps [ScopedModel.of] for this [Model].
  static UrlEmbedModel of(BuildContext context) =>
      ScopedModel.of<UrlEmbedModel>(context);

  void fetchHtml(url) {
    http.get(url).then((response) {
      if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var document = parse(response.body);

      var list = document.getElementsByTagName('meta');

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

        notifyListeners();
      }
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    });
  }
}