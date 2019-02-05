import 'package:flutter/material.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/models/PostListModel.dart';
import 'package:flutter_punch/models/PostModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:youtube_player/youtube_player.dart';
import 'package:flutter_punch/screens/imageViewer.dart';
import 'package:universal_widget/universal_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/scopedModels/PostListSM.dart';
import 'package:flutter_punch/widgets/FullScreenLoadingWidget.dart';
import 'package:flutter_punch/widgets/FPDrawerWidget.dart';
import 'package:flutter_punch/helpers/Ratings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadModel thread;

  ThreadScreen({@required this.thread});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  PostListModel postList = new PostListModel(posts: new List<PostModel>());
  ScrollController _scrollController = new ScrollController();
  PostListSM _model = PostListSM();
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();

    String urlWithCurrentPageNumber =
        widget.thread.url.replaceAll('/1/', '/' + pageNumber.toString() + '/');

    _model.updateLoadingState(true);
    _model.getPosts(urlWithCurrentPageNumber).then((onValue) {
      _model.updateLoadingState(false);

      if (_model.posts.totalPages > 1) {
        UniversalWidget.find("paginator")
            .update(duration: 0.5, height: 50.0, opacity: 1);
      }
    });
  }

  void changePage(int number) {
    print(number.toString().length);

    int oldNumber = _model.pageNumber;

    print(widget.thread.url);

    String urlWithCurrentPageNumber = widget.thread.url;
    urlWithCurrentPageNumber = urlWithCurrentPageNumber.substring(
        0, urlWithCurrentPageNumber.length - (number.toString().length + 2));

    urlWithCurrentPageNumber =
        urlWithCurrentPageNumber + "/" + number.toString() + "/";

    print(urlWithCurrentPageNumber);

    _model.updateLoadingState(true);
    _model.getPosts(urlWithCurrentPageNumber).then((nothing) {
      _model.updatePageNumber(number);
      _model.updateLoadingState(false);

      _scrollController.jumpTo(0.0);
    });
  }

  // Handle the different widget types!
  Widget handleWidget(dom.Node node) {
    print(node.attributes);

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
          child: Hero(
            tag: node.attributes['url'],
            child: Image(
              image: AdvancedNetworkImage(node.attributes['url'],
                  useDiskCache: true),
            ),
          ),
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
      default:
        return Text('unknown type');
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
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: model.posts.posts.length,
      itemBuilder: (context, index) {
        var post = model.posts.posts[index];

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
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
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
                ),
              ),
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
              ),
              Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: postFooter(post),
              )
            ],
          ),
        );
      },
    );
  }

  Widget postFooter(PostModel post) {
    print(post.meta.votes);

    List<Widget> voteWidgets = new List();

    if (post.meta.votes != null && post.meta.votes.length > 0) {
      for (var vote in post.meta.votes.keys) {
        Rating rating = RatingsHelper()
            .RatingsList
            .where((i) => i.id == int.parse(vote))
            .first;

        if (rating.icon.contains(".svg")) {
          voteWidgets.add(
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
          voteWidgets.add(
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

    return Row(children: voteWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.title),
      ),
      bottomNavigationBar: UniversalWidget(
        name: "paginator",
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
        child: ScopedModel<PostListSM>(
          model: _model,
          child: new ScopedModelDescendant<PostListSM>(
            builder: (context, child, model) {
              return AnimatedCrossFade(
                duration: Duration(milliseconds: 300),
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                crossFadeState: model.isLoading
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: loadingContent(model),
                secondChild: content(model),
              );
            },
          ),
        ),
      ),
      drawer: FPDrawerWidget(),
    );
  }
}
