import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_punch/helpers/ColorHelper.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryTitle;
  final List<ForumsModel> forums;
  final ValueChanged<ForumsModel> onForumTap;

  CategoryWidget(
      {@required this.categoryTitle,
      @required this.forums,
      @required this.onForumTap});

  //  Row(children: forums.map((forum) => Text(forum.title)).toList()),

  Widget isSVGOrImage(String forumId, String icon) {
    Widget child;

    if (forumId == "gmodgd" || forumId == "rust") {
      return Image(
        image: NetworkImage(icon),
        width: 30,
      );
    } else if (forumId == "vidz") {
      return Image(
        image: NetworkImage(icon),
        width: 30,
      );
    } else {
      return SvgPicture(
        AdvancedNetworkSvg(icon, SvgPicture.svgByteDecoder, useDiskCache: true),
        width: 30,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
              color: categoryHeaderItemBackground(context),
              border: new Border.all(color: categoryHeaderItemBorder(context))),
          padding: EdgeInsets.all(16.0),
          child: Text(categoryTitle),
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: forums
                .map((forum) => InkWell(
                    onTap: () => onForumTap(forum),
                    child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 16.0),
                              child: isSVGOrImage(forum.id, forum.icon),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(forum.title,
                                      style: TextStyle(fontSize: 16.0, color: Colors.blue[400], fontWeight: FontWeight.bold)),
                                  Text(forum.subtitle,
                                      style: TextStyle(fontSize: 14.0, color: Colors.grey))
                                ],
                              ),
                            )
                          ],
                        ))))
                .toList(),
          ),
        ),
      ],
    );
  }
}
