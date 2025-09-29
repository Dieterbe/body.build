import 'dart:async';
import 'package:bodybuild/ui/datetime.dart';
import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  final DateTime start;
  final TextStyle? style;

  const Stopwatch({super.key, required this.start, this.style});

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = DateTime.now().difference(widget.start);
    return Text(
      formatHumanDuration(duration),
      style:
          widget.style ??
          Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
