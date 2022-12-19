import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_compresser/Utils/url_launch.dart';
import 'package:in_app_review/in_app_review.dart';

class Drawer_Widget extends StatelessWidget {
  Drawer_Widget({Key? key}) : super(key: key);
  final InAppReview inAppReview = InAppReview.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 39, 38, 38),
      child: SingleChildScrollView(child: builddrawerContent(context)),
    );
  }

  Widget builddrawerContent(context) {
    final color = Colors.white;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Container(
          child: Image.asset(
            'assets/logo.png',
            scale: 5,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 0, bottom: 5, left: 30),
          child: InkWell(
            onTap: () => FlutterShare.share(
                title: 'Compressor',
                text: 'Compressor: Images & Videos',
                linkUrl:
                    'https://play.google.com/store/apps/details?id=com.mythics.video_compresser',
                chooserTitle: 'Compressor: Images & Videos'),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: color,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Share',
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 30),
          child: InkWell(
            onTap: () {
              launchlinks(
                  context,
                  'https://play.google.com/store/apps/dev?id=6922841044913065499',
                  'https://play.google.com/store/apps/dev?id=6922841044913065499');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.app_registration,
                    color: color,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'More Apps',
                    style: TextStyle(color: color),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 30),
          child: InkWell(
            onTap: () {
              launchlinks(
                  context,
                  'https://mythicsstudio.in/index.php/compressor-privacy-policy/',
                  'https://mythicsstudio.in/index.php/compressor-privacy-policy/');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_sharp,
                    color: color,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 30),
          child: InkWell(
            onTap: () {
              inAppReview.openStoreListing(
                  appStoreId: 'com.mythics.video_compresser');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: color,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Rate Our App',
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 30),
          child: InkWell(
            onTap: () {
              final link = 'https://mythicsstudio.in/';
              launchlinks(context, link, link);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developed and Desgined by Mythics Studio',
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Copyright Mythics Studio 2022',
                        style: TextStyle(color: color, fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
