// ignore_for_file: unused_import

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compresser/Utils/AdUnitIdHelper.dart';
import 'package:video_compresser/compressors/thumbnail_generator.dart';
import 'package:video_compresser/pages/adjestor.dart';
import 'package:video_compresser/pages/settings.dart';
import 'package:video_compresser/widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../Utils/url_launch.dart';
import '../Utils/variables.dart';
import '../widgets/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();

  File? videoFile;
  File? thumbnail;

  late InterstitialAd _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isAdloaded = false;

  void loadad2() async {
    await InterstitialAd.load(
        adUnitId: AdUnitHelper.getAfterInterstitialAdUnitId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded2,
            onAdFailedToLoad: (error) {
              print('failed to load the ad landing page err - ' +
                  error.toString());
            }));
  }

  void onAdLoaded2(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAdloaded = true;
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isAdloaded = false;
        ad.dispose();
      },
    );
  }

  late InterstitialAd _oyeinterstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isOyeAdloaded = false;

  void loadad() {
    InterstitialAd.load(
        adUnitId: AdUnitHelper.getHomeInterstitialAdUnitId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded,
            onAdFailedToLoad: (error) {
              print('failed to load the ad landing page err - ' +
                  error.toString());
            }));
  }

  void onAdLoaded(InterstitialAd ad) {
    _oyeinterstitialAd = ad;
    _isOyeAdloaded = true;
    _oyeinterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isOyeAdloaded = false;
        ad.dispose();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkperms();

    openad().showAdIfAvailable();
    _createBottomBannerAd();
    loadad();
    loadad2();
    checkversion();
  }

  Route _createRoute(page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void checkversion() async {
    firestore.DocumentSnapshot data = await firestore.FirebaseFirestore.instance
        .collection('admin')
        .doc('controls')
        .get();
    print(data);
    var version =
        Platform.isIOS ? data['ios_app_version'] : data['app_version'];
    int native_version;
    if (Platform.isIOS) {
      native_version = i_app_version;
    } else {
      native_version = g_app_version;
    }

    if (version > native_version) {
      if (mounted)
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Update Available!'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'A new version of our app is Available, update now to keep enjoying the app.'),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              launchlinks(
                                  context,
                                  'https://play.google.com/store/apps/details?id=com.mythics.video_compresser',
                                  'https://play.google.com/store/apps/details?id=com.mythics.video_compresser');
                            },
                            child: Text('Lets Update'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
    }
    print(version);
  }

  checkperms() async {
    var storage_status = await Permission.storage.status;

    if (storage_status.isDenied) {
      await Permission.storage.request();
    }
    var media_status = await Permission.photos.status;

    if (media_status.isDenied) {
      await Permission.photos.request();
    }
    var external_status = await Permission.manageExternalStorage.status;

    if (external_status.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    print(external_status);
    print(storage_status);
    print(media_status);
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1000)).floor();

    print(
        ((bytes / pow(1000, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i]);
    return ((bytes / pow(1000, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_isBottomBannerAdLoaded) _bottomBannerAd.dispose();
    if (_isOyeAdloaded) _oyeinterstitialAd.dispose();
    super.dispose();
  }

  bool _isBottomBannerAdLoaded = false;
  late BannerAd _bottomBannerAd;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdUnitHelper.getHomeBannerAdUnitId(),
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
      drawer: Drawer(child: Drawer_Widget()),
      appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                if (_isAdloaded) {
                  _interstitialAd.show();
                } else {
                  Fluttertoast.showToast(msg: 'Ad not loaded');
                }
              },
              child: Center(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/play_icon.png',
                      scale: 3,
                    ),
                    Text(
                      'AD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: (() {
                Navigator.of(context).push(_createRoute(Settings()));
              }),
            ),
          ],
          title: Text(
            'Compressor',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.red,
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light,
          )),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Choose What To Compress',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 15,
            ),
            _CardBlock('assets/image.png', 'Compress Image', () {
              if (_isOyeAdloaded) {
                _oyeinterstitialAd.show();
              } else {
                pickvideo(ImageSource.gallery, context, false);
              }
            }),
            SizedBox(
              height: 15,
            ),
            _CardBlock('assets/video.png', 'Compress Video', () {
              if (_isOyeAdloaded) {
                _oyeinterstitialAd.show();
              } else {
                pickvideo(ImageSource.gallery, context, true);
              }
            }),
            SizedBox(
              height: 30,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: _isBottomBannerAdLoaded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
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
          ],
        ),
      ),
    );
  }

  String? oldfilesize;

  pickvideo(ImageSource src, BuildContext context, bool isvideo) async {
    try {
      final video = isvideo
          ? await ImagePicker().pickVideo(
              source: src,
            )
          : await ImagePicker().pickImage(
              source: src,
            );

      final pickedfile = File(video!.path);
      final _File = pickedfile;
      videoFile = _File;
      oldfilesize = await getFileSize(_File.path, 1);
      if (isvideo) {
        thumbnail = await Thumbnail.generateThumbnail(_File);
      } else {
        thumbnail = _File;
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Adjester(
                    filetype: isvideo,
                    file: _File,
                    preview_image: thumbnail!,
                    orignal_filesize: oldfilesize!,
                  )));
    } catch (e) {
      print(e);
    }
  }

  Widget _CardBlock(image, title, ontap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: ontap,
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 5,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 9,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    image,
                    scale: 1.2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
