import 'package:bodybuild/ui/core/text_style.dart';
import 'package:bodybuild/ui/programmer/widget/kv_row.dart';
import 'package:bodybuild/ui/programmer/widget/widgets.dart';
import 'package:flutter/material.dart';

class KVStringsRow extends StatelessWidget {
  final String title;
  final String val;
  final String? help;
  final Widget? helpWidget;

  const KVStringsRow(this.title, this.val,
      {this.help, this.helpWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return KVRow(
      titleTextMedium(title, context),
      v: Text(val, style: ts100(context)),
      help: help,
      helpTitle: title,
      helpWidget: helpWidget,
    );
  }
}
