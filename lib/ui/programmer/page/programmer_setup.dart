import 'package:flutter/material.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_facts.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_filters.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_inputs.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_params.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_params_overrides.dart';
import 'package:ptc/ui/programmer/widget/setup_profile_header.dart';

class ProgrammerSetup extends StatelessWidget {
  const ProgrammerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SetupProfileHeader(),
        ),
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
