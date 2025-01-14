import 'package:bodybuild/ui/core/info_button.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class KStringRow extends StatelessWidget {
  final String title;
  final String? help;

  const KStringRow(this.title, {this.help, super.key});

  @override
  Widget build(BuildContext context) {
    final spacer = MediaQuery.sizeOf(context).width / 150;

    return Row(
      children: [
        titleTextMedium(title, context),
        if (help != null) SizedBox(width: spacer),
        (help == null)
            ? SizedBox(width: 40 + spacer)
            : InfoButton(
                title: title,
                child: MarkdownBody(
                  data: help!,
                ),
              ),
        Flexible(flex: 8, child: Container()),
      ],
    );
  }
}
