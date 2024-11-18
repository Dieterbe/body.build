import 'package:flutter/material.dart';
import 'package:ptc/data/programmer/exercises.dart';
import 'package:ptc/data/programmer/groups.dart';
import 'package:ptc/model/programmer/set_group.dart';
import 'package:ptc/model/programmer/settings.dart';
import 'package:ptc/ui/programmer/util_groups.dart';
import 'package:ptc/ui/programmer/widget/equip_label.dart';
import 'package:ptc/ui/programmer/widget/widgets.dart';

class BuilderSetGroup extends StatelessWidget {
  final SetGroup sg;
  final Settings setup;
  final Function(SetGroup? sgNew) onChange;

  const BuilderSetGroup(this.setup, this.sg, this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Row(children: [
        const SizedBox(width: 16),
        SizedBox(
          width: 45,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: sg.n,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
              items: List.generate(10, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                onChange(sg.copyWith(n: newValue));
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 45,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              // if you go back and change the setup, we must reset the intensity to something that's allowed
              value: (setup.paramFinal.intensities.contains(sg.intensity))
                  ? sg.intensity
                  : setup.paramFinal.intensities.first,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
              items: setup.paramFinal.intensities
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                onChange(sg.copyWith(intensity: newValue));
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            onChange(sg.copyWith(changeEx: !sg.changeEx));
          },
          icon: Icon(
            Icons.edit,
            size: 20,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
          style: IconButton.styleFrom(
            backgroundColor: sg.changeEx
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            onChange(null);
          },
          icon: Icon(
            Icons.delete_outline,
            size: 20,
            color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          ),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          width: 250,
          height: 40,
          child: (sg.ex != null && !sg.changeEx)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      sg.ex!.id,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ))
              : Autocomplete<Ex>(
                  displayStringForOption: (e) => e.id,
                  optionsBuilder: (textEditingValue) {
                    return exes
                        .where((e) => e.id
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .toList();
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onEditingComplete: onFieldSubmitted,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        hintText: 'Search exercise...',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (Ex e) {
                    onChange(sg.copyWith(ex: e, changeEx: false));
                  }),
        ),
        const SizedBox(width: 16),
        if (sg.ex != null)
          ...sg.ex!.equipment.map((e) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: EquipmentLabel(e),
              )),
        Expanded(child: Container()),
        // muscle recruitment values
        ...ProgramGroup.values.map(
          (g) => Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: bgColorForProgramGroup(g),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Center(
                child: muscleMark(
                    sg.ex == null ? 0 : sg.ex!.recruitment(g), context)),
          ),
        ),
      ]),
    );
  }
}
