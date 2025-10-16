import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_facts.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_filters.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_inputs.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_params.dart';

class ProgrammerSetup extends StatelessWidget {
  const ProgrammerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Padding(padding: EdgeInsets.all(8.0), child: ProgrammerSetupInputs()),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(children: [ProgrammerSetupFacts(), ProgrammerSetupParams()]),
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(8.0), child: ProgrammerSetupFilters()),
      ],
    );
  }
}
