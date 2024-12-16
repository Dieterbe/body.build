import 'package:flutter/material.dart';

class LabelBar extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const LabelBar(this.title, {super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 8),
      Row(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...children,
          Expanded(child: Container()),
        ],
      ),
      Divider(
          height: 2,
          thickness: 2,
          color: Theme.of(context).colorScheme.secondaryContainer),
      const SizedBox(height: 8),
    ]);
  }
}
