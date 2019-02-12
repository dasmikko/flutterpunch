import 'package:flutter/material.dart';
import 'package:flutter_punch/screens/login.dart';
import 'package:flutter_punch/scopedModels/DrawerModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class FPDrawerWidget extends StatefulWidget {
  @override
  _FPDrawerWidgetState createState() => _FPDrawerWidgetState();
}

class _FPDrawerWidgetState extends State<FPDrawerWidget> {
  @override
  void initState() {
    super.initState();

    ScopedModel.of<DrawerModel>(context).updateLoginState();
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
                  padding: EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
                  margin: EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    )
                  ),
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
              "https://auth.facepunch.com/login/?r=aHR0cHM6Ly9mb3J1bS5mYWNlcHVuY2guY29tLz9uYz0xMjY2MmM%3D");

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
