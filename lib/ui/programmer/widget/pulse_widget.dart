import 'package:flutter/material.dart';

class PulseWidget extends StatefulWidget {
  final Widget child;
  final bool pulse;

  const PulseWidget({
    required this.child,
    this.pulse = false,
    super.key,
  });

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pulse) return widget.child;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

class PulseMessageWidget extends StatelessWidget {
  final Widget child;
  final bool pulse;
  final String msg;
  const PulseMessageWidget(
      {super.key, required this.child, required this.msg, this.pulse = false});

  @override
  Widget build(BuildContext context) {
    return PulseWidget(
        pulse: pulse,
        child: pulse
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  const SizedBox(height: 8),
                  Text(
                    msg,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )
            : child);
  }
}
