import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/CategoryModel.dart';
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/widgets/CategoryWidget.dart';
import 'dart:convert';
import 'package:flutter_punch/screens/forum.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Punch');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CategoryListModel categoryList =
      new CategoryListModel(categories: new List<CategoryModel>());

  @override
  void initState() {
    super.initState();

    fetchCategories().then((data) {
      print(data.categories[0].categoryName);
      setState(() {
        categoryList = data;
      });
    });
  }

  Future<CategoryListModel> fetchCategories() async {
    print('Fetching categories');
    final response = await http.get('https://facepunch-api-eu.herokuapp.com/');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return CategoryListModel.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void _incrementCounter() {
    fetchCategories().then((data) {
      setState(() {
        categoryList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          itemCount: categoryList.categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CategoryWidget(
                    categoryTitle: categoryList.categories[index].categoryName,
                    forums: categoryList.categories[index].forums,
                    onForumTap: (ForumsModel forum) {
                      print('Clicked forum ${forum.title}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForumScreen(forum: forum)),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
