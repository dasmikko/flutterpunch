import 'package:flutter/material.dart';
import 'package:flutter_punch/scopedModels/UrlEmbedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class EmbedWidget extends StatelessWidget {
  String url;

  EmbedWidget(this.url);

  bool notNull(Object o) => o != null;

  Widget handleImage (String url) {
    return TransitionToImage(
      image: AdvancedNetworkImage(url),
      placeholder: CircularProgressIndicator(),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    UrlEmbedModel _model = new UrlEmbedModel();

    _model.fetchHtml(url);

    //UrlEmbedModel.of(context).fetchHtml(this.url);
    return new ScopedModel<UrlEmbedModel>(
      model: _model,
      child: new ScopedModelDescendant<UrlEmbedModel>(
        builder: (context, child, model) {
          // Embed content
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Column(
                children: <Widget>[
                  model.imageUrl != null
                      ? handleImage(model.imageUrl)
                      : null,
                  ListTile(
                    title: Text(model.title),
                    subtitle: Text(model.description),
                  ),
                ].where(notNull).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
