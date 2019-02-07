import 'package:flutter/material.dart';

class FPDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Not logged in"),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Login (Not available)'),
              enabled: false,
            ),
            ListTile(
              title: Text('Settings (Not available)'),
              enabled: false,
            ),
          ],
        ),
      );
  }
}