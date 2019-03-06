import 'package:flutter/material.dart';
import 'package:flutter_punch/models/AlertsModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_punch/helpers/ColorHelper.dart';

class AlertsHelper {
  bool notNull(Object o) => o != null;

  Widget alertHandler(SingleAlertModel alert, BuildContext context) {
    switch (alert.alertType) {
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
      case 1: // Level up
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
                  Text("You've levelled up! Welcome to level ${alert.dataNumber}")
                ],
              ),
            )
          ],
        );
        break;
      case 2: // quoted
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
      case 3: // mentioned
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
                        TextSpan(text: ' mentioned you in ', style: TextStyle(fontWeight: FontWeight.normal)),
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
      case 4: // newthread
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
                        TextSpan(text: ' posted ', style: TextStyle(fontWeight: FontWeight.normal)),
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
      case 5: // accepted
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
                        TextSpan(text: ' accepted your answer in ', style: TextStyle(fontWeight: FontWeight.normal)),
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
      case 6: // replied to thread
        int dataNumberAsInt = alert.dataNumber.toInt();

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
                        alert.dataNumber != null && alert.dataNumber > 1 ? TextSpan(text: ' and ', style: TextStyle(fontWeight: FontWeight.normal)) : null,
                        alert.dataNumber != null && alert.dataNumber > 1 ? TextSpan(text: "${dataNumberAsInt-1} ", style: TextStyle(fontWeight: FontWeight.bold)) : null,
                        alert.dataNumber != null && alert.dataNumber > 2 ? TextSpan(text: "others", style: TextStyle(fontWeight: FontWeight.bold)) : TextSpan(text: "other", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' replied to ', style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(text: alert.thread.name, style: TextStyle(fontWeight: FontWeight.bold))
                      ].where(notNull).toList()
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case 7: // Bannedcheat
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
                      text: "Thanks - we have banned banned someone due to your report",
                      style: TextStyle(fontWeight: FontWeight.bold, color: alertListItemText(context, alert.seen)),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case 8: // rating
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
                        TextSpan(text: ' rated your post in ', style: TextStyle(fontWeight: FontWeight.normal)),
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
