import 'package:flutter/material.dart';
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/models/ThreadListModel.dart';
import 'package:flutter_punch/models/ThreadModel.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/widgets/ThreadListItem.dart';
import 'package:flutter_punch/screens/thread.dart';

class ForumScreen extends StatefulWidget {
  final ForumsModel forum;

  ForumScreen({@required this.forum});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ForumScreen> {
  ThreadListModel threadList =
      new ThreadListModel(threads: new List<ThreadModel>());

  @override
  void initState() {
    super.initState();

    APIHelper().fetchForum(widget.forum.id).then((data) {
      print(data.threads[0].title);
      setState(() {
        threadList = data;
      });
    });
  }

  void onTapThread(ThreadModel thread) {
    print(thread.url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThreadScreen(thread: thread)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forum.title),
      ),
      body: Container(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1.0,
              ),
          itemCount: threadList.threads.length,
          itemBuilder: (BuildContext context, int index) {
            return ThreadListItem(
              thread: threadList.threads[index],
              onTapItem: onTapThread,
            );
          },
        ),
      ),
    );
  }
}
