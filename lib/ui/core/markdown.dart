import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

Widget markdown(String body) {
  return MarkdownBody(
    data: body,
    onTapLink: (text, url, title) {
      if (url == null) {
        return;
      }
      launchUrl(Uri.parse(url));
    },
  );
}
