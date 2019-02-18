import 'package:flutter/material.dart';
import 'package:flutter_punch/screens/login.dart';
import 'package:flutter_punch/scopedModels/DrawerModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_punch/helpers/API.dart';
import 'package:flutter_punch/helpers/Alerts.dart';
import 'package:flutter_punch/models/AlertsModel.dart';
import 'package:flutter_punch/screens/thread.dart';
import 'package:flutter_punch/models/ThreadModel.dart';

class FPDrawerWidget extends StatefulWidget {
  @override
  _FPDrawerWidgetState createState() => _FPDrawerWidgetState();
}

class _FPDrawerWidgetState extends State<FPDrawerWidget> {
  @override
  void initState() {
    super.initState();

    ScopedModel.of<DrawerModel>(context).updateLoginState();
    ScopedModel.of<DrawerModel>(context).updateAlertCount();
  }

  bool notNull(Object o) => o != null;

  void _showAlertsDialog(
      BuildContext context, List<SingleAlertModel> alerts) async {
    List<Widget> alertsWidgetList = new List();

    alerts.forEach((alert) {
      alertsWidgetList.add(InkWell(
        onTap: () {
          print(alert.forum.url);
          print(alert.thread.threadid);

          double pages = alert.thread.postcount / 30;
          int pagenumber = ((alert.post.postnumber -1) / 30).ceil();

          String url = alert.forum.url + '/' + alert.thread.threadid + '/' + pagenumber.toString() + '/';

          ThreadModel thread = new ThreadModel(url: url, title: alert.thread.name, pageNumber: pagenumber);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThreadScreen(thread: thread)),
          );
        },
        child: Container(
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
          decoration: BoxDecoration(
            color: alert.seen ? Colors.grey.withOpacity(0.3) : Colors.white,
            border: BorderDirectional(
              top: BorderSide(color: Colors.grey),
            ),
          ),
          child: AlertsHelper().alertHandler(alert),
        ),
      ));
    });

    SimpleDialog dialog = SimpleDialog(
      title: Text('Alerts'),
      children: alertsWidgetList,
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.all(18),
    );

    var rating = await showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  List<Widget> loggedInList(context) {
    final username =
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).username;
    final backgroundImage =
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true)
            .backgroundImage;
    final avatar =
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).avatar;

    final level =
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).level;

    final alertCount = 
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).alertsCount;

    final alerts = 
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).alerts;

    return <Widget>[
      DrawerHeader(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 64,
                  width: 64,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AdvancedNetworkImage(
                        avatar,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  username,
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
                  margin: EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Text(
                    level.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AdvancedNetworkImage(
              backgroundImage,
            ),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
        ),
      ),
      ListTile(
        title: Container(
          child: Row(
            children: <Widget>[
              Text('Alerts'),
              alertCount > 0 ? Container(
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
                  margin: EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Text(
                    alertCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
              ) : null,
            ].where(notNull).toList()
          )
        ),
        onTap: () async {
          _showAlertsDialog(context, alerts);
        },
      ),
      ListTile(
        title: Text('Logout'),
        onTap: () async {
          ScopedModel.of<DrawerModel>(context).logout();
          CookieManager.deleteAllCookies();
        },
      ),
      ListTile(
        title: Text('Settings (Not available)'),
        enabled: false,
      ),
    ];
  }

  List<Widget> loggedOutList(context) {
    return <Widget>[
      DrawerHeader(
        child: Text("Not logged in"),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
      ),
      ListTile(
        title: Text('Login'),
        onTap: () async {
          final flutterWebviewPlugin = new FlutterWebviewPlugin();

          flutterWebviewPlugin.onUrlChanged.listen((String url) async {
            print(url);
            if (url.contains("forum.facepunch.com")) {
              var cookies = await CookieManager.getCookies(
                  "https://forum.facepunch.com/");
              SharedPreferences prefs = await SharedPreferences.getInstance();

              String cookieString = '';

              // Get needed
              cookies.forEach((element) {
                if (element['name'] == 'fp_edt')
                  cookieString +=
                      element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_sid')
                  cookieString +=
                      element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_uid')
                  cookieString +=
                      element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_gid')
                  cookieString +=
                      element['name'] + "=" + element['value'] + "; ";
              });

              await prefs.setBool('isLoggedIn', true);
              await prefs.setString('cookieString', cookieString);

              ScopedModel.of<DrawerModel>(context).updateLoginState();

              flutterWebviewPlugin.close();
            }
          });

          flutterWebviewPlugin.launch(
            "https://auth.facepunch.com/login/?r=aHR0cHM6Ly9mb3J1bS5mYWNlcHVuY2guY29tLz9uYz0xMjY2MmM%3D",
            userAgent:
                "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
          );

          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );*/
        },
      ),
      ListTile(
        title: Text('Settings (Not available)'),
        enabled: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedInState =
        ScopedModel.of<DrawerModel>(context, rebuildOnChange: true).isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:
            isLoggedInState ? loggedInList(context) : loggedOutList(context),
      ),
    );
  }
}
