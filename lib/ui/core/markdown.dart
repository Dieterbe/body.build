import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

Widget markdown(String body, BuildContext context) {
  return MarkdownBody(
    data: body,
    styleSheet: MarkdownStyleSheet(
      p: TextStyle(color: Theme.of(context).hintColor),
      a: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTapLink: (text, url, title) {
      if (url == null) {
        return;
      }
      launchUrl(Uri.parse(url));
    },
  );
}
