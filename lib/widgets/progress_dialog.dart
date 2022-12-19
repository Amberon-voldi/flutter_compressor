import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

import '../compressors/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({Key? key}) : super(key: key);

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  double? progress;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;

    return Container(
      height: MediaQuery.of(context).size.height / 4,
      padding: EdgeInsets.all(20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Compressing, Please wait...',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 20,
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.grey,
          color: Colors.red,
          value: value,
          minHeight: 12,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            onTap: (() async {
              Navigator.pop(context);
              FFmpegKit.cancel();
            }),
            child: Container(
              height: MediaQuery.of(context).size.height / 13,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
