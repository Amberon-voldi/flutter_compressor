import 'dart:io';
import 'package:video_compress/video_compress.dart';

class Thumbnail {
  static generateThumbnail(File file) async {
    final getthumbnail = await VideoCompress.getFileThumbnail(file.path);
    return getthumbnail;
  }
}
