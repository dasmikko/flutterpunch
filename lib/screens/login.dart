import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        child: InAppWebView(
          initialUrl: "https://auth.facepunch.com/login/?r=aHR0cHM6Ly9mb3J1bS5mYWNlcHVuY2guY29tLz9uYz0xMjY2MmM%3D",
          initialOptions: {
            
            'useShouldOverrideUrlLoading': true,
          },
          shouldOverrideUrlLoading: (InAppWebViewController controller, String url) async {
            print(url);

            // If on forum.facepunch.com page, we have logged in!
            if (url.contains("forum.facepunch.com")) {
              var cookies = await CookieManager.getCookies("https://forum.facepunch.com/");
              SharedPreferences prefs = await SharedPreferences.getInstance();

              String cookieString = '';
              
              // Get needed 
              cookies.forEach((element) {
                if (element['name'] == 'fp_edt') cookieString += element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_sid') cookieString += element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_uid') cookieString += element['name'] + "=" + element['value'] + "; ";
                if (element['name'] == 'fp_gid') cookieString += element['name'] + "=" + element['value'] + "; ";
              });

              await prefs.setBool('isLoggedIn', true);
              await prefs.setString('cookieString', cookieString);

              Navigator.pop(context);
            }
            

            
            controller.loadUrl(url);
          },
        ),
      ),

    );
  }
}