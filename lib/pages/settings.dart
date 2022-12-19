import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Utils/AdUnitIdHelper.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isBottomBannerAdLoaded = false;
  late BannerAd _bottomBannerAd;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdUnitHelper.getSettingsBannerAdUnitId(),
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
  void initState() {
    // TODO: implement initState
    _createBottomBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_isBottomBannerAdLoaded) _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Column(children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Save Path',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '/storage/emulated/0/DCIM/Compressor',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Version',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '1.0.0+1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ],
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
