import 'package:bodybuild/ui/core/info_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class KVRow extends StatelessWidget {
  final Widget k;
  final Widget v;
  final String? help;
  final String? helpTitle; // if help non null, helpTitle is required
  const KVRow(this.k, this.v, {this.help, this.helpTitle, super.key});

  @override
  Widget build(BuildContext context) {
    final spacer = MediaQuery.sizeOf(context).width / 150;
    return Row(
      children: [
        k,
        SizedBox(width: spacer),
        Expanded(flex: 8, child: v),
        if (help != null) SizedBox(width: spacer),
        (help == null)
            ? SizedBox(width: 40 + spacer)
            : InfoButton(
                title: helpTitle!,
                child: MarkdownBody(
                  data: help!,
                ),
              ),
      ],
    );
  }
}
