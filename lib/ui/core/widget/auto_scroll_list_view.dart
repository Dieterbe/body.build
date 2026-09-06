import 'package:flutter/widgets.dart';

class AutoScrollList extends StatefulWidget {
  const AutoScrollList({super.key, required this.builder});

  final Widget Function(BuildContext context, ScrollController controller) builder;

  @override
  State<AutoScrollList> createState() => _AutoScrollListState();
}

class _AutoScrollListState extends State<AutoScrollList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);
}
