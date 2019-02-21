import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_punch/helpers/Ratings.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:flutter_punch/helpers/ColorHelper.dart';

Widget userNameText(String userRank, String username) {
  switch (userRank) {
    case 'normal':
      return Text(
        username,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      );
      break;
    case 'gold':
      return Text(
        username,
        style: TextStyle(
            color: Colors.yellowAccent[700], fontWeight: FontWeight.bold),
      );
      break;
    case 'moderator':
      return Text(
        username,
        style: TextStyle(color: Colors.green[500], fontWeight: FontWeight.bold),
      );
      break;
    case 'admin':
      return Text(
        username,
        style: TextStyle(color: Colors.green[500], fontWeight: FontWeight.bold),
      );
      break;
    default:
      return Text(
          username,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        );
  }
}

Widget postHeader(
    PostModel post, BuildContext context, ScrollController scrollController) {
  if (post.user.backgroundImage != null) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: postHeaderNoBackground(context),
        border: BorderDirectional(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: new ParallaxImage(
        image: AdvancedNetworkImage(
          post.user.backgroundImage,
        ),
        extent: 50.0,
        // Optionally specify child widget.
        child: Container(
          padding: EdgeInsets.only(
            left: 14.0,
            right: 14.0,
            top: 8.0,
            bottom: 8.0,
          ),
          color: postHeaderBackground(context),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 18.0),
                child: post.user.avatar != null
                    ? Image(
                        height: 28.0,
                        image: AdvancedNetworkImage(
                          post.user.avatar,
                        ),
                      )
                    : null,
              ),
              userNameText(post.user.userRank, post.user.username)
            ],
          ),
        ),
        // Optinally specify scroll controller.
        controller: scrollController,
      ),
    );
  } else {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: postHeaderNoBackground(context),
        border: BorderDirectional(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Container(
        height: 60,
        padding: EdgeInsets.only(
          left: 14.0,
          right: 14.0,
          top: 8.0,
          bottom: 8.0,
        ),
        color: postHeaderBackground(context),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 18.0),
              child: post.user.avatar != null
                  ? Image(
                      height: 28.0,
                      image: AdvancedNetworkImage(
                        post.user.avatar,
                      ),
                    )
                  : null,
            ),
            userNameText(post.user.userRank, post.user.username)
          ],
        ),
      ),
    );
  }
}
