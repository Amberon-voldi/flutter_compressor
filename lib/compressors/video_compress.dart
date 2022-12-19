import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_compresser/Utils/Show_Notification.dart';

import '../pages/PostCompressPage.dart';
import '../widgets/progress_dialog.dart';

class Compress {
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

  Future go(
      File file, context, String orignal_filesize, File preview_image) async {
    try {
      var downloadsPath = await getExternalStorageDirectory();
      var datetime = DateTime.now();
      final myImagePath = '${downloadsPath!.path}/Compressor';
      // create folder if not exists
      final myImageFolder = Directory(myImagePath); // set path to folder
      if (!(await myImageFolder.exists())) {
        // if folder not exists, create folder
        await myImageFolder.create();
      }

      var pathOfImage = await File('${myImagePath}/compressed.mp4').create();

      var outpath = pathOfImage.path;
      print(outpath);
      String command =
          "-y -i ${file.path} -c:a copy -c:v libx264 -b:v 200k -b:a 200k -crf 35 $outpath";
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: ProgressDialogWidget(),
            );
          });
      FFmpegKit.executeAsync(command, (Session session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          print("compressed done");
          shownotification('Compressor', 'Video compressed');

          File lastVid = File(pathOfImage.path);

          Navigator.pop(context);
          final newfilesize = await getFileSize(lastVid!.path!, 1);
          var file = lastVid;
          var g = Uint8List.fromList(pathOfImage.path.codeUnits);
          GallerySaver.saveVideo(pathOfImage.path);
          // await SaverGallery.saveImage(g,
          //     quality: 60,
          //     name: '${datetime}_compressed',
          //     fileExtension: 'mp4',
          //     isReturnImagePathOfIOS: true,
          //     androidRelativePath: "DCIM/video_compressor/");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PostCompression(
                      new_filesize: newfilesize!,
                      filetype: false,
                      file: file,
                      preview_image: preview_image,
                      orignal_filesize: orignal_filesize)));
          //SUCCESS
        } else if (ReturnCode.isCancel(returnCode)) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Compression Failed');
          print("Failed");
          // CANCEL

        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: 'Compression Failed, Something went wrong');
          print("something went wrong");
          FFmpegKitConfig.enableLogCallback((log) {
            final message = log.getMessage();
            print(message);
          });
          // ERROR

        }
      });
    } catch (e) {
      print('videocompress falied');
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
