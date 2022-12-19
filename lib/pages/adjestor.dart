import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_compresser/compressors/image_compress.dart';
import 'package:video_compresser/compressors/video_compress.dart';
import 'package:video_compresser/pages/PostCompressPage.dart';

import '../widgets/progress_dialog.dart';

class Adjester extends StatefulWidget {
  File file;
  bool filetype;
  File preview_image;
  String orignal_filesize;
  Adjester(
      {required this.filetype,
      required this.file,
      required this.preview_image,
      required this.orignal_filesize});

  @override
  State<Adjester> createState() => _AdjesterState();
}

class _AdjesterState extends State<Adjester> {
  bool deleteorignal = false;
  double slidervalue = 50.0;
  String quality = '50';
  String? newfilesize;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1000)).floor();
    newfilesize =
        ((bytes / pow(1000, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
    print(
        ((bytes / pow(1000, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i]);
    return ((bytes / pow(1000, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
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
              'File Size: ' + widget.orignal_filesize,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                'Adjest Quality',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Text(
                'x$quality',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Slider(
              max: 100.0,
              activeColor: Colors.red,
              value: slidervalue,
              onChanged: (value) {
                setState(() {
                  slidervalue = value;
                  quality = value.toInt().toString();
                });
                print(value);
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                'Delete Orignal?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Switch(
                  activeColor: Colors.red,
                  inactiveTrackColor: Colors.grey,
                  value: deleteorignal,
                  onChanged: (value) {
                    setState(() {
                      if (deleteorignal) {
                        deleteorignal = false;
                      } else {
                        deleteorignal = true;
                      }
                    });
                  }),
            ],
          ),
        ),
        InkWell(
          onTap: (() async {
            if (widget.filetype) {
              Compress().go(widget.file, context, widget.orignal_filesize,
                  widget!.preview_image!);
            } else {
              final compressedimage =
                  await ImageCompress.ImageCompressAndGetFile(
                          widget.file, widget.file.path, slidervalue)
                      .then((value) async {
                await getFileSize(value!.path!, 1);
                var file = value;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostCompression(
                            new_filesize: newfilesize!,
                            filetype: false,
                            file: file,
                            preview_image: widget.preview_image,
                            orignal_filesize: widget.orignal_filesize)));
              });
            }
          }),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 11,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              'Compress',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
