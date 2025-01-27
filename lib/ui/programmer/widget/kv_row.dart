import 'package:bodybuild/ui/core/info_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class KVRow extends StatelessWidget {
  final Widget k;
  final Widget? v;
  final String? help;
  final Widget? helpWidget;
  final String? helpTitle; // required if help or helpWidget != null
  const KVRow(this.k,
      {this.v, this.help, this.helpTitle, this.helpWidget, super.key});

  @override
  Widget build(BuildContext context) {
    final spacer = MediaQuery.sizeOf(context).width / 150;
    Widget? hw;
    if (helpWidget != null) {
      hw = InfoButton(
        title: helpTitle!,
        child: helpWidget!,
      );
    } else if (help != null) {
      hw = InfoButton(
        title: helpTitle!,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: MarkdownBody(
            data: help!,
          ),
        ),
      );
    }
    return Row(
      children: [
        k,
        if (v != null) SizedBox(width: spacer),
        if (v != null) Expanded(flex: 8, child: v!),
        if (hw != null) SizedBox(width: spacer),
        (hw == null) ? SizedBox(width: 40 + spacer) : hw,
      ],
    );
  }
}
