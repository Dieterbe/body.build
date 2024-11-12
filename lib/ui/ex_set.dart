import 'package:flutter/material.dart';
import 'package:ptc/programming/ex_set.dart';
import 'package:ptc/programming/exercises.dart';

class ExSetWidget extends StatelessWidget {
  final void Function(Ex) onSelected;
  final ExSet s;
  const ExSetWidget(this.s, this.onSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (s.ex != null) Text(s.ex!.id),
        if (s.ex == null)
          SizedBox(
            width: 200,
            height: 40,
            child: Autocomplete<Ex>(
              displayStringForOption: (e) => e.id,
              optionsBuilder: (textEditingValue) {
                return exes
                    .where((e) => e.id
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()))
                    .toList();
              },
              onSelected: onSelected,
            ),
          ),
      ],
    );
  }
}
