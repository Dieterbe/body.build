//  const MarkdownBody(data: markdownSource),
import 'package:flutter/material.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_inputs.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_params.dart';
import 'package:ptc/ui/programmer/page/programmer_setup_params_overrides.dart';

class ProgrammerSetup extends StatelessWidget {
  const ProgrammerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgrammerSetupParams(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgrammerSetupParamOverrides(),
          ),
        ),
      ],
    );
  }
}
