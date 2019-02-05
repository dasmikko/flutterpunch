import 'package:flutter/material.dart';

class FullScreenLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) - 80,
              left: (MediaQuery.of(context).size.width / 2) - 40,
              child: Container(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(strokeWidth: 4,),
              ),
            ),
          ],
        ));
  }
}
