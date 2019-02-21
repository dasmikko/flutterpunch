import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DownloadHelper {
  void downloadFile(String url, GlobalKey<ScaffoldState> scaffoldKey) {
    SimplePermissions.checkPermission(Permission.WriteExternalStorage)
        .then((hasPermission) async {
      if (hasPermission) {
        try {
          var dir = await getExternalStorageDirectory();
          var fileName = basename(url);

          // Create directory if not existing!
          new Directory.fromUri(new Uri.file(dir.path + '/NewpunchDroid/'))
              .createSync(recursive: true);

          Dio()
              .download(url, "${dir.path}/newpunchDroid/${fileName}")
              .then((response) {
            if (response.statusCode == 200) {
              scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: Text("${fileName} was downloaded"),
              ));
            } else {
              scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: Text("${fileName} was not downloaded"),
              ));
            }
          });
        } catch (e) {
          print(e);
        }
      } else {
        var dir = await getApplicationDocumentsDirectory();
        var fileName = basename(url);

        // Create directory if not existing!
        new Directory.fromUri(new Uri.file(dir.path + '/NewpunchDroid/'))
            .createSync(recursive: true);

        SimplePermissions.requestPermission(Permission.WriteExternalStorage)
            .then((gavePermission) {
          if (gavePermission == PermissionStatus.authorized) {
            Dio()
                .downloadUri(Uri.parse(url),
                    "${dir.path}/newpunchDroid/${fileName}")
                .then((response) {
              if (response.statusCode == 200) {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text("${fileName} was downloaded"),
                ));
              } else {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text("${fileName} was not downloaded"),
                ));
              }
            });
          }
        });
      }
    });
  }
}
