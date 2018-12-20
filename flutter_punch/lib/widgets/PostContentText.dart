import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:real_rich_text/real_rich_text.dart';

class PostContentText extends StatelessWidget {
  final PostContentModel postContent;

  PostContentText({@required this.postContent});

  @override
  Widget build(BuildContext context) {
    PostContentTextOptionsModel options = postContent.options;
    List<PostContentTextChildModel> children = options.children;

    List<TextSpan> textItems = new List<TextSpan>();

    print(options.text);

    textItems.add(TextSpan(text: options.text));

    children.toList().forEach((item) {
      if (item.attributes.isEmote) {
        textItems.add(ImageSpan(
          NetworkImage(
              "https://files.facepunch.com/garry/e4f979d2-7c3f-476c-a893-23d1375c94e5.png"),
          imageWidth: 24,
          imageHeight: 24,
        ));
      } else if (item.attributes.isMention) {
        textItems.add(TextSpan(
            text: item.mention.username,
            style: TextStyle(
                fontWeight: item.attributes.bold ? FontWeight.bold : null)));
      } else {
        textItems.add(TextSpan(
            text: item.text,
            style: TextStyle(
                fontWeight: item.attributes.bold ? FontWeight.bold : null)));
      }
    });

    return Container(
      child: RealRichText(textItems),
    );
  }
}
