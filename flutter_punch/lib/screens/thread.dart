import 'package:flutter/material.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_punch/widgets/PostContentText.dart';
import 'package:flutter_punch/widgets/PostContentPostQuote.dart';
import 'package:flutter_punch/widgets/PostContentHotlink.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:youtube_player/youtube_player.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadModel thread;

  ThreadScreen({@required this.thread});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  PostListModel postList = new PostListModel(posts: new List<PostModel>());
  ScrollController _scrollController = new ScrollController();
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();

    String urlWithCurrentPageNumber =
        widget.thread.url.replaceAll('/1/', '/' + pageNumber.toString() + '/');

    APIHelper().fetchThread(urlWithCurrentPageNumber).then((data) {
      setState(() {
        postList = data;
      });
    });
  }

  void changePage(int number) {
    print(number.toString().length);

    int oldNumber = pageNumber;

    print(widget.thread.url);

    String urlWithCurrentPageNumber = widget.thread.url;
    urlWithCurrentPageNumber = urlWithCurrentPageNumber.substring(
        0, urlWithCurrentPageNumber.length - (number.toString().length + 2));

    urlWithCurrentPageNumber =
        urlWithCurrentPageNumber + "/" + number.toString() + "/";

    print(urlWithCurrentPageNumber);

    APIHelper().fetchThread(urlWithCurrentPageNumber).then((data) {
      setState(() {
        pageNumber = number;
        postList = data;
      });

      _scrollController.jumpTo(0.0);
    });
  }

  // Handle the different widget types!
  Widget handleWidget(dom.Node node) {
    print(node.attributes);

    switch (node.attributes['contenttype']) {
      case 'image':
        return Image(
          image:
              AdvancedNetworkImage(node.attributes['url'], useDiskCache: true),
        );
        break;
      case 'youtube':
        return Container(
          child: Column(
            children: <Widget>[
              YoutubePlayer(
                source: node.attributes['url'],
                quality: YoutubeQuality.HD,
                aspectRatio: 16 / 9,
                showThumbnail: true,
                autoPlay: false,
              ),
            ],
          ),
        );
        break;
      case 'postquote':
        return Container(
          color: Colors.blue,
          child: Column(
            children: <Widget>[Text('PostQuote'), Text(node.text)],
          ),
        );
        break;
      default:
        return Text('unknown type');
    }
  }

  Widget handlePostquote(dom.Node node) {
    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.blue, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  node.attributes['username'] + " posted:",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      color: Colors.white24,
                      child: Text(
                        node.text,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.title),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: pageNumber != 1 ? () {
                if (pageNumber != 1) {
                  changePage(pageNumber - 1);
                }
              } : null,
            ),
            Text(pageNumber.toString() +
                " of " +
                postList.totalPages.toString()),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: pageNumber != postList.totalPages ? () {
                if (pageNumber < postList.totalPages) {
                  changePage(pageNumber + 1);
                }
              } : null,
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: postList.posts.length,
          itemBuilder: (context, index) {
            var post = postList.posts[index];

            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      // Post header
                      padding: EdgeInsets.only(
                        left: 14.0,
                        right: 14.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: post.user.backgroundImage != null
                          ? BoxDecoration(
                              border: BorderDirectional(
                                top: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                              image: DecorationImage(
                                image: AdvancedNetworkImage(
                                  post.user.backgroundImage,
                                ),
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.dstATop),
                              ),
                            )
                          : BoxDecoration(
                              color: Colors.blueGrey[50],
                              border: BorderDirectional(
                                top: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 18.0),
                            child: post.user.avatar != null
                                ? Image(
                                    height: 28.0,
                                    image: NetworkImage(post.user.avatar),
                                  )
                                : null,
                          ),
                          Text(post.user.username),
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Html(
                      data: post.contentAsHtml,
                      customRender: (node, children) {
                        if (node is dom.Element) {
                          switch (node.localName) {
                            case "hotlink":
                              return handleWidget(node);
                              break;
                            case "postquote":
                              return handlePostquote(node);
                              break;
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
