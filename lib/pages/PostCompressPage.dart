import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Utils/AdUnitIdHelper.dart';

class PostCompression extends StatefulWidget {
  File file;
  bool filetype;
  File preview_image;
  String new_filesize;
  String orignal_filesize;
  PostCompression(
      {required this.new_filesize,
      required this.filetype,
      required this.file,
      required this.preview_image,
      required this.orignal_filesize});

  @override
  State<PostCompression> createState() => _PostCompressionState();
}

class _PostCompressionState extends State<PostCompression> {
  @override
  void initState() {
    // TODO: implement initSta
    _createBottomBannerAd();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_isBottomBannerAdLoaded) _bottomBannerAd.dispose();

    super.dispose();
  }

  bool _isBottomBannerAdLoaded = false;
  late BannerAd _bottomBannerAd;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdUnitHelper.getAfterCompBannerAdUnitId(),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print(
              '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +
                  error.toString());
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text('Compressor'),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Image.file(
            widget.preview_image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Orignal Size: ' + widget.orignal_filesize,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'New Size: ' + widget.new_filesize,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Path: ' + widget.file.path,
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Center(
            child: Row(
              children: [
                Text(
                  'Compressed File!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: _isBottomBannerAdLoaded
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                    width: _bottomBannerAd.size.width.toDouble(),
                    height: _bottomBannerAd.size.height.toDouble(),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: AdWidget(ad: _bottomBannerAd)),
                  ),
                )
              : Center(
                  child: Text(
                    'Ad Space',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                ),
        )
      ]),
    );
  }
}
