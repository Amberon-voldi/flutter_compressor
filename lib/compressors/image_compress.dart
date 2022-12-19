import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_compresser/Utils/Show_Notification.dart';

class ImageCompress {
  static Future<File?> ImageCompressAndGetFile(
      File file, String targetPath, double quality) async {
    try {
      var perquality;
      if (quality <= 50) {
        perquality = 20;
      } else if (quality >= 50) {
        perquality = 34;
      }
      var downloadsPath = Platform.isIOS
          ? await getExternalStorageDirectory()
          : await getExternalStorageDirectory();

      print(downloadsPath);
      var datetime = DateTime.now();
      final pathOfImage =
          await File('${downloadsPath!.path}/${datetime}_compressed.jpeg')
              .create();

      var result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          quality: perquality,
          format: CompressFormat.jpeg);
      await pathOfImage.writeAsBytes(result!);
      shownotification('Compressor', 'Image compressed');
      // await SaverGallery.saveImage(result!,
      //     quality: 60,
      //     name: 'Compressed_Image',
      //     androidRelativePath:
      //         "Pictures/video_compressor/${datetime}_compressed.jpg");

      GallerySaver.saveImage(pathOfImage.path);

      return File(pathOfImage.path);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'Compression failed');
    }
  }
}
