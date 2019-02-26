import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_punch/screens/imageViewer.dart';
import 'package:universal_widget/universal_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/scopedModels/PostListSM.dart';
import 'package:flutter_punch/widgets/FullScreenLoadingWidget.dart';
import 'package:flutter_punch/widgets/FPDrawerWidget.dart';
import 'package:flutter_punch/widgets/PostElements/Video.dart';
import 'package:flutter_punch/widgets/PostElements/Embed.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_punch/widgets/PostElements/PostFooter.dart';
import 'package:flutter_punch/widgets/PostElements/PostHeader.dart';
import 'package:flutter_punch/widgets/PostElements/Youtube.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadModel thread;
  final bool useUnreadUrl;

  ThreadScreen({@required this.thread, this.useUnreadUrl});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  PostListModel postList = new PostListModel(posts: new List<PostModel>());
  ScrollController _scrollController = new ScrollController();
  PostListSM _model = PostListSM();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    if (widget.thread.pageNumber != null) {
      _model.updatePageNumber(widget.thread.pageNumber);
    }

    if (widget.useUnreadUrl) {
      var query = widget.thread.lastUnreadUrl.split('/');
      int pageNumber = int.parse(query.elementAt(query.length - 2));
      _model.updatePageNumber(pageNumber);
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> _refresh() {
    String urlWithCurrentPageNumber = widget.thread.url;

    urlWithCurrentPageNumber = urlWithCurrentPageNumber.substring(
        0,
        urlWithCurrentPageNumber.length -
            (_model.pageNumber.toString().length + 2));

    urlWithCurrentPageNumber =
        urlWithCurrentPageNumber + "/" + _model.pageNumber.toString() + "/";

    return _model.getPosts(urlWithCurrentPageNumber).then((onValue) {
      print('posts fetched');
      _scrollController.jumpTo(0);
      if (_model.posts.totalPages > 1) {
        print('show pagnation');
        UniversalWidget.find("paginatorThread")
            .update(duration: 0.5, height: 50.0, opacity: 1);
      }
    });
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void changePage(int number) {
    _model.updatePageNumber(number);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  // Handle the different widget types!
  Widget handleWidget(dom.Node node) {
    switch (node.attributes['contenttype']) {
      case 'image':
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ImageViewerScreen(url: node.attributes['url'])),
            );
          },
          child: Container(
            height: 200,
            margin: EdgeInsets.only(bottom: 8.0),
            child: Hero(
              tag: node.attributes['url'],
              child: TransitionToImage(
                image: AdvancedNetworkImage(node.attributes['url'],
                    useDiskCache: true)
              ),
            ),
          ),
        );
        break;
      case 'youtube':
        return YouTubeEmbed(url: node.attributes['url'].toString());
        break;
      case 'video':
        return VideoElement(node.attributes['url']);
      default:
        return EmbedWidget(node.attributes['url']);
    }
  }

  Widget handlePostquote(dom.Node node) {
    return Row(children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.only(bottom: 12.0),
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

  Widget loadingContent(model) {
    return FullScreenLoadingWidget();
  }

  Widget content(model) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: model.posts.posts.length,
      itemBuilder: (context, index) {
        var post = model.posts.posts[index];

        return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              postHeader(post, context, _scrollController),
              Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Html(
                  data: post.contentAsHtml,
                  onLinkTap: (url) {
                    launchUrl(url);
                  },
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
              ),
              Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: postFooter(post, () => _refreshIndicatorKey.currentState.show(), context),
              )
            ],
          ),
        );
      },
    );
  }

  

  void showJumpDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: _model.posts.totalPages,
            title: new Text("Jump to page"),
            initialIntegerValue: _model.posts.currentPage,
          );
        }).then((int value) {
      if (value != null) changePage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.redo),
            tooltip: "Jump to page",
            onPressed: showJumpDialog,
          )
        ],
      ),
      bottomNavigationBar: UniversalWidget(
        name: "paginatorThread",
        height: _model.posts.posts.length > 0 && _model.posts.totalPages > 1
            ? 50.0
            : 0.0,
        opacity: _model.posts.posts.length > 0 && _model.posts.totalPages > 1
            ? 1
            : 0.0,
        visible: true,
        child: ScopedModel<PostListSM>(
          model: _model,
          child: new ScopedModelDescendant<PostListSM>(
              builder: (context, child, model) {
            return BottomAppBar(
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: model.pageNumber != 1
                        ? () {
                            if (model.pageNumber != 1) {
                              changePage(model.pageNumber - 1);
                            }
                          }
                        : null,
                  ),
                  Text("Page " +
                      model.pageNumber.toString() +
                      " of " +
                      model.posts.totalPages.toString()),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: model.pageNumber != model.posts.totalPages
                        ? () {
                            if (model.pageNumber < model.posts.totalPages) {
                              changePage(model.pageNumber + 1);
                            }
                          }
                        : null,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _refresh,
          key: _refreshIndicatorKey,
          child: ScopedModel<PostListSM>(
              model: _model,
              child: new ScopedModelDescendant<PostListSM>(
                  builder: (context, child, model) {
                return content(model);
              })),
        ),
      ),
      drawer: FPDrawerWidget(),
    );
  }
}
