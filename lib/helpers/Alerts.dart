import 'package:flutter/material.dart';
import 'package:flutter_punch/models/AlertsModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_punch/helpers/ColorHelper.dart';

class AlertsHelper {
  Widget alertHandler(SingleAlertModel alert, BuildContext context) {
    switch (alert.alertType) {
      case 6: // replied to thread
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: SvgPicture(
                AdvancedNetworkSvg(alert.icon, SvgPicture.svgByteDecoder,
                    useDiskCache: true),
                width: 30,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: alert.user.username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: alertListItemText(context, alert.seen)),
                      children: <TextSpan>[
                        TextSpan(text: ' replied to ', style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: alert.thread.name, style: TextStyle(fontWeight: FontWeight.bold))
                      ]
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case 2: // replied to post
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: SvgPicture(
                AdvancedNetworkSvg(alert.icon, SvgPicture.svgByteDecoder,
                    useDiskCache: true),
                width: 30,
              ),
            ),
            Flexible(
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: alert.user.username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: alertListItemText(context, alert.seen)),
                      children: <TextSpan>[
                        TextSpan(text: ' replied to yout post in ', style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: alert.thread.name, style: TextStyle(fontWeight: FontWeight.bold))
                      ]
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case 0: // Coins
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: SvgPicture(
                AdvancedNetworkSvg(alert.icon, SvgPicture.svgByteDecoder,
                    useDiskCache: true),
                width: 30,
              ),
            ),
            Flexible(
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: alert.user.username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: alertListItemText(context, alert.seen)),
                      children: <TextSpan>[
                        TextSpan(text: ' gave you ', style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: alert.dataNumber.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        alert.dataNumber > 1 ? TextSpan(text: ' coins', style: TextStyle(fontWeight: FontWeight.bold)) : TextSpan(text: ' coin', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' for your post in ', style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: alert.thread.name, style: TextStyle(fontWeight: FontWeight.bold))
                      ]
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      default:
        return Container(
          child: Text(alert.alertType.toString()),
        );
    }
  }
}
