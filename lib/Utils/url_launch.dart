import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

launchlinks(context, IosLink, AndriodLink) async {
  if (Platform.isIOS) {
    final Url = Uri.parse(IosLink);
    if (await canLaunchUrl(Url)) {
      await launchUrl(Url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: new Text('Unable to connect with the app')));
    }
  } else {
    final url = Uri.parse(AndriodLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: new Text('Unable to connect with the app')));
    }
  }
}
