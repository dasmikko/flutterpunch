import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_punch/helpers/ColorHelper.dart';
import 'package:universal_widget/universal_widget.dart';

class ThreadListItem extends StatelessWidget {
  final ThreadModel thread;
  final ValueChanged<ThreadModel> onTapItem;
  final ValueChanged<ThreadModel> onTapUnread;

  ThreadListItem(
      {@required this.thread, @required this.onTapItem, this.onTapUnread});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(thread),
      child: Container(
        decoration: BoxDecoration(
            color: threadListItemBackground(thread.isSticky, context)),
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 14.0),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(14.0),
              child: SvgPicture(
                AdvancedNetworkSvg(thread.icon, SvgPicture.svgByteDecoder,
                    useDiskCache: true),
                width: 30,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      thread.title,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: threadListItemTitle(thread.isSticky, context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        thread.creator.username,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: thread.isSticky
                                ? Colors.green[800]
                                : Colors.blue[800],
                            fontWeight: FontWeight.bold),
                      ),
                      UniversalWidget(
                        visible: thread.unreadPostsCount > 0 ? true : false,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffaaaa46)),
                            color: Colors.yellow[100],
                          ),
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            onTap: () => onTapUnread(thread),
                            child: Text(
                              "${thread.unreadPostsCount} unread",
                              style: TextStyle(color: Color(0xffaaaa46)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
