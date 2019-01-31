import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThreadListItem extends StatelessWidget {
  final ThreadModel thread;
  final ValueChanged<ThreadModel> onTapItem;

  ThreadListItem({@required this.thread, @required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapItem(thread),
      child: Container(
        decoration:
            BoxDecoration(color: thread.isSticky ? Colors.green[100] : null),
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
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    thread.creator.username,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold),
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
