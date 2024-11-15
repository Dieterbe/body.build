import 'package:flutter/material.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/data/programmer/exercises.dart';

class SetGroupWidget extends StatelessWidget {
  final void Function(Ex) onSelected;
  final SetGroup s;
  const SetGroupWidget(this.s, this.onSelected, {super.key});

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
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  TextField(
                controller: textEditingController,
              ),
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
