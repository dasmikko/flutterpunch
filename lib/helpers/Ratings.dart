import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingsHelper {
  final List<Rating> ratingsList = [
    new Rating(
        id: 1,
        name: "Agree",
        icon:
            "https://files.facepunch.com/garry/771bf748-b2a3-48cb-bafa-74630263eeb6.svg",
        cost: 0),
    new Rating(
        id: 2,
        name: "Disagree",
        icon:
            "https://files.facepunch.com/garry/fefbad1c-787b-4407-92d1-c9ea358db311.svg",
        cost: 0),
    new Rating(
        id: 3,
        name: "Funny",
        icon:
            "https://files.facepunch.com/garry/e06a8775-edd5-4b1e-b501-0601fa9ea3c0.png",
        cost: 0),
    new Rating(
        id: 4,
        name: "Late",
        icon:
            "https://files.facepunch.com/garry/bd14ff9a-e314-4419-bfd0-92093b61eceb.svg",
        cost: 0),
    new Rating(
        id: 5,
        name: "Friendly",
        icon:
            "https://files.facepunch.com/garry/faa43d70-512c-4c80-950c-93ef7c2adb7a.svg",
        cost: 0),
    new Rating(
        id: 6,
        name: "Sympathy",
        icon:
            "https://files.facepunch.com/garry/0466446f-7bb9-42bb-a2fb-e661603163cd.svg",
        cost: 0),
    new Rating(
        id: 7,
        name: "Artistic",
        icon:
            "https://files.facepunch.com/garry/8e6d1b56-6edf-4541-b063-a8ec9912a9c7.svg",
        cost: 0),
    new Rating(
        id: 8,
        name: "Winner",
        icon:
            "https://files.facepunch.com/garry/41c9e74a-0c66-4c00-a1d1-778877999913.svg",
        cost: 0),
    new Rating(
        id: 9,
        name: "Dumb",
        icon:
            "https://files.facepunch.com/garry/5d811f04-27a1-446b-8271-ef7cd728964e.svg",
        cost: 0),
    new Rating(
        id: 10,
        name: "Baby",
        icon:
            "https://files.facepunch.com/garry/55de84c0-9123-4ab1-b546-edfda25f6976.svg",
        cost: 0),
    new Rating(
        id: 11,
        name: "Coin",
        icon:
            "https://files.facepunch.com/garry/982f16eb-9932-4b32-93b3-9640c27d1883.svg",
        cost: 1),
    new Rating(
        id: 12,
        name: "Good Idea",
        icon:
            "https://files.facepunch.com/garry/526b7380-11d6-449c-ab61-6bdf750cc53e.svg",
        cost: 0),
    new Rating(
        id: 13,
        name: "Snowflake",
        icon:
            "https://files.facepunch.com/garry/c532c93a-498f-4ea4-8883-f5a0b6e30385.svg",
        cost: 0),
    new Rating(
        id: 14,
        name: "Diamond",
        icon:
            "https://files.facepunch.com/garry/2bb0589b-5b93-4d58-a214-82f906f9c002.svg",
        cost: 10),
    new Rating(
        id: 15,
        name: "Asshole",
        icon:
            "https://files.facepunch.com/garry/68bd0566-0008-442d-89e2-6c3eb26cd96c.svg",
        cost: 0),
    new Rating(
        id: 16,
        name: "Bad Spelling",
        icon:
            "https://files.facepunch.com/garry/a67eaf60-e9fb-4479-a7e9-1b051c4f0b13.svg",
        cost: 0),
    new Rating(
        id: 17,
        name: "Bad Reading",
        icon:
            "https://files.facepunch.com/garry/4320530b-2ea0-4329-887f-866ce51df5b8.svg",
        cost: 0),
    new Rating(
        id: 18,
        name: "Cute",
        icon:
            "https://files.facepunch.com/garry/516a8e6c-9303-4609-a1e6-6a00d3ac56ec.svg",
        cost: 0),
    new Rating(
        id: 19,
        name: "Lucky",
        icon:
            "https://files.facepunch.com/garry/df54b61e-2f03-42bb-bb8b-a5fe3dff586f.svg",
        cost: 0),
    new Rating(
        id: 20,
        name: "Big Whoop",
        icon:
            "https://files.facepunch.com/garry/8fc20d94-6b62-491b-afd5-85eaf3017277.svg",
        cost: 0),
    new Rating(
        id: 21,
        name: "Informative",
        icon:
            "https://files.facepunch.com/garry/6242f2b6-8c3c-4478-9102-19f7d0884280.svg",
        cost: 0),
  ];

  List<Widget> toOptionsList(Function onPressed) {
    List<Widget> list = new List();

    ratingsList.forEach((element) {
      if (element.icon.contains('.svg')) {
        list.add(
          SimpleDialogOption(
            onPressed: () => onPressed(element.id),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: SvgPicture(
                            AdvancedNetworkSvg(
                                element.icon, SvgPicture.svgByteDecoder,
                                useDiskCache: true),
                            width: 30),
                      )
                    ],
                  ),
                ),
                Text(element.name),
              ],
            ),
          ),
        );
      } else {
        list.add(
          SimpleDialogOption(
            onPressed: () => onPressed(element.id),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Image(
                          image: AdvancedNetworkImage(element.icon,
                              useDiskCache: true),
                          width: 30),
                      ),
                      Text(element.name)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return list;
  }
}

class Rating {
  final int id;
  final String name;
  final String icon;
  final int cost;

  Rating({this.id, this.name, this.icon, this.cost});
}
