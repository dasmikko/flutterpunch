import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_punch/models/CategoryListModel.dart';
import 'package:flutter_punch/models/CategoryModel.dart';
import 'package:flutter_punch/models/ForumsModel.dart';
import 'package:flutter_punch/widgets/CategoryWidget.dart';
import 'package:flutter_punch/screens/forum.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_punch/scopedModels/CategoryModel.dart';
import 'package:flutter_punch/widgets/FullScreenLoadingWidget.dart';
import 'package:flutter_punch/widgets/FPDrawerWidget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Newpunch Droid');
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
  CategoryModelScoped _categoryModelScoped = CategoryModelScoped();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

    // Fetch the categories
    _categoryModelScoped.updateLoadingState(true);
    _categoryModelScoped.getCategories().then((nothing) {
      _categoryModelScoped.updateLoadingState(false);
    });
  }

  Future<void> _reload() {
    // Fetch the categories
    _categoryModelScoped.updateLoadingState(true);
    return _categoryModelScoped.getCategories().then((nothing) {
      _categoryModelScoped.updateLoadingState(false);
    });
  }

  Widget loadingContent(model) {
    return FullScreenLoadingWidget();
  }

  Widget content(model) {
    return Container(
      alignment: Alignment.center,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _reload,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _categoryModelScoped.categories.categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CategoryWidget(
                    categoryTitle: _categoryModelScoped
                        .categories.categories[index].categoryName,
                    forums: _categoryModelScoped
                        .categories.categories[index].forums,
                    onForumTap: (ForumsModel forum) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForumScreen(forum: forum)),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
        child: ScopedModel<CategoryModelScoped>(
          model: _categoryModelScoped,
          child: new ScopedModelDescendant<CategoryModelScoped>(
              builder: (context, child, model) {
            return content(model);
          }),
        ),
      ),
      drawer: FPDrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _reload,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
