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
    return Row(children: [
      const SizedBox(width: 10),
      SizedBox(
        width: 45,
        child: DropdownButton<int>(
          value: sg.n,
          items: List.generate(10, (index) => index + 1)
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (int? newValue) {
            onChange(sg.copyWith(n: newValue));
          },
        ),
      ),
      const SizedBox(width: 10),
      SizedBox(
        width: 45,
        child: DropdownButton<int>(
          // if you go back and change the setup, we must reset the intensity to something that's allowed
          value: (setup.paramFinal.intensities.contains(sg.intensity))
              ? sg.intensity
              : setup.paramFinal.intensities.first,
          items: setup.paramFinal.intensities
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (int? newValue) {
            onChange(sg.copyWith(intensity: newValue));
          },
        ),
      ),
      IconButton(
        onPressed: () {
          onChange(sg.copyWith(changeEx: !sg.changeEx));
        },
        icon: const Icon(Icons.edit),
        style: IconButton.styleFrom(
            //  minimumSize: const Size(40, 40), -- used to work
            ),
      ),
      IconButton(
        onPressed: () {
          onChange(null);
        },
        icon: const Icon(Icons.delete),
        style: IconButton.styleFrom(
            //  minimumSize: const Size(40, 40), -- used to work
            ),
      ),
      SizedBox(
        width: 200,
        height: 40,
        child: (sg.ex != null && !sg.changeEx)
            ? Align(alignment: Alignment.center, child: Text(sg.ex!.id))
            : Autocomplete<Ex>(
                displayStringForOption: (e) => e.id,
                optionsBuilder: (textEditingValue) {
                  return exes
                      .where((e) => e.id
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                onSelected: (Ex e) {
                  onChange(sg.copyWith(ex: e));
                }),
      ),
      const SizedBox(width: 10),
      if (sg.ex != null) ...sg.ex!.equipment.map((e) => EquipmentLabel(e)),
      Expanded(child: Container()),
      ...ProgramGroup.values.map(
        (g) => Container(
          height: 40,
          //  width: 40,
          color: bgColorForProgramGroup(g),
          child: Center(
              child: muscleMark(
                  sg.ex == null ? 0 : sg.ex!.recruitment(g), context)),
        ),
      ),
    ]);
  }
}
