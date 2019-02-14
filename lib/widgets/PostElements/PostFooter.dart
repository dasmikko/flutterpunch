import 'package:flutter/material.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_punch/helpers/Ratings.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_punch/helpers/API.dart';

Widget postFooter(
    PostModel post, Function refreshMethod, BuildContext context) {
  List<Widget> firstColumn = new List();
  List<Widget> lastColumn = new List();

  if (post.meta.votes != null && post.meta.votes.length > 0) {
    for (var vote in post.meta.votes.keys) {
      Rating rating = RatingsHelper()
          .ratingsList
          .where((i) => i.id == int.parse(vote))
          .first;

      if (rating.icon.contains(".svg")) {
        firstColumn.add(
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: Column(
              children: <Widget>[
                SvgPicture(
                    AdvancedNetworkSvg(rating.icon, SvgPicture.svgByteDecoder,
                        useDiskCache: true),
                    width: 30),
                Text(post.meta.votes[vote].toString())
              ],
            ),
          ),
        );
      } else {
        firstColumn.add(
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: Column(
              children: <Widget>[
                Image(
                    image:
                        AdvancedNetworkImage(rating.icon, useDiskCache: true),
                    width: 30),
                Text(post.meta.votes[vote].toString())
              ],
            ),
          ),
        );
      }
    }
  }

  if (post.canVote) {
    lastColumn.add(FlatButton(
      child: Text('Rate'),
      onPressed: () {
        _showVoteDialog(post.postId, context, refreshMethod);
      },
    ));
  }

  return Row(children: <Widget>[
    Expanded(
      child: Column(
        children: <Widget>[
          Row(children: firstColumn),
        ],
      ),
    ),
    Column(children: lastColumn)
  ]);
}

void _showVoteDialog(
    int postid, BuildContext context, Function refreshMethod) async {
  SimpleDialog dialog = SimpleDialog(
    title: Text('Rate post'),
    children: RatingsHelper().toOptionsList(
      (id) {
        Navigator.pop(context, id);
      },
    ),
  );

  var rating = await showDialog(
      context: context, builder: (BuildContext context) => dialog);

  if (rating != null) {
    print(rating);

    // Diamond or coin = show warning
    if (rating == 14 || rating == 11) {
      var answer = await _showWarningDialog(context);

      if (answer) {
        await APIHelper().ratePost(postid, rating);

        final snackBar = SnackBar(content: Text('Post was rated!'));
        Scaffold.of(context).showSnackBar(snackBar);

        refreshMethod();
      }
    } else {
      await APIHelper().ratePost(postid, rating);

      final snackBar = SnackBar(content: Text('Post was rated!'));
      Scaffold.of(context).showSnackBar(snackBar);

      refreshMethod();
    }
  }
}

Future<bool> _showWarningDialog(context) async {
  var answer = await showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text('This rating will cost you coins, are you sure you want to do this?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () => Navigator.pop(context, true),
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context, false),
        )
      ],
    );
  });

  return answer;
}
