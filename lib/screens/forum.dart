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

  @override
  void initState() {
    super.initState();

    print(widget.forum.id);
    _model.updateLoadingState(true);
    _model.getForum(widget.forum.id).then((val) {
      _model.updateLoadingState(false);

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

  void changePage(int number) {
    _model.updateLoadingState(true);


    var url = widget.forum.id;

    if (number > 1) {
      url = url + "/p/" + number.toString();
    }

    _model.getForum(url).then((nothing) {
        print("should jump in list");
      _model.updatePageNumber(number);
      _model.updateLoadingState(false);  
    });
  }

  Widget loadingContent(model) {
    return FullScreenLoadingWidget();
  }

  Widget content(model) {
    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1.0,
            ),
        itemCount: model.thread.threads.length,
        itemBuilder: (BuildContext context, int index) {
          return ThreadListItem(
            thread: model.thread.threads[index],
            onTapItem: onTapThread,
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
