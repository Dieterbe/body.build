import 'package:flutter/material.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_facts.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_filters.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_inputs.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_params.dart';
import 'package:bodybuild/ui/programmer/page/programmer_setup_params_overrides.dart';

class ProgrammerSetup extends StatelessWidget {
  const ProgrammerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProgrammerSetupInputs(),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const ProgrammerSetupFacts(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: ProgrammerSetupParams()),
                        Expanded(child: ProgrammerSetupParamOverrides()),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: ProgrammerSetupFilters(),
        ),
      ],
    );
  }
}
