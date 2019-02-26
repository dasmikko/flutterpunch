import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/widgets/ThreadListItem.dart';
import 'package:flutter_punch/screens/thread.dart';
import 'package:flutter_punch/scopedModels/ForumModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/widgets/FullScreenLoadingWidget.dart';
import 'package:flutter_punch/widgets/FPDrawerWidget.dart';
import 'package:universal_widget/universal_widget.dart';

class ForumScreen extends StatefulWidget {
  final ForumsModel forum;

  ForumScreen({@required this.forum});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ForumScreen> {
  ThreadListModel threadList =
      new ThreadListModel(threads: new List<ThreadModel>());
  ForumModelScoped _model = ForumModelScoped();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

    print(widget.forum.id);
  }

  Future<void> _refresh() {
    var url = widget.forum.id;

    if (_model.pageNumber > 1) {
      url = url + "/p/" + _model.pageNumber.toString();
    }

    return _model.getForum(url).then((val) {
      if (_model.thread.totalPages > 1) {
        UniversalWidget.find("paginator")
            .update(duration: 0.5, height: 50.0, opacity: 1);
      }
    });
  }

  void onTapThread(ThreadModel thread) {
    print(thread.url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThreadScreen(thread: thread)),
    );
  }

  void onTapUnread(ThreadModel thread) {
    print(thread.url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThreadScreen(thread: thread, useUnreadUrl: true,)),
    );
  }

  void changePage(int number) {
    _model.updatePageNumber(number);
    _refreshIndicatorKey.currentState.show();
  }

  Widget loadingContent(model) {
    return FullScreenLoadingWidget();
  }

  Widget content(model) {
    return Container(
      child:  ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1.0,
            ),
        itemCount: model.thread.threads.length,
        itemBuilder: (BuildContext context, int index) {
          return ThreadListItem(
            thread: model.thread.threads[index],
            onTapItem: onTapThread,
            onTapUnread: onTapUnread,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forum.title),
      ),
      bottomNavigationBar: UniversalWidget(
        name: "paginator",
        height: _model.thread.threads.length > 0 && _model.thread.totalPages > 1
            ? 50.0
            : 0.0,
        opacity: _model.thread.threads.length > 0 && _model.thread.totalPages > 1
            ? 1
            : 0.0,
        visible: true,
        child: ScopedModel<ForumModelScoped>(
          model: _model,
          child: new ScopedModelDescendant<ForumModelScoped>(
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
                      model.thread.totalPages.toString()),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: model.pageNumber != model.thread.totalPages
                        ? () {
                            if (model.pageNumber < model.thread.totalPages) {
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
        child: ScopedModel<ForumModelScoped>(
          model: _model,
          child: new ScopedModelDescendant<ForumModelScoped>(
            builder: (context, child, model) {
              return  RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child:content(model));
            },
          ),
        ),
      ),
      drawer: FPDrawerWidget(),
    );
  }
}
