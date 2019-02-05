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

    _model.updateLoadingState(true);
    _model.getForum(widget.forum.id).then((val) {
      _model.updateLoadingState(false);
    });
  }

  void onTapThread(ThreadModel thread) {
    print(thread.url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThreadScreen(thread: thread)),
    );
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
