import 'package:flutter/material.dart';
import 'package:ptc/ui/anatomy/colors.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({
    super.key,
    required this.height,
    required this.width,
    required this.p1,
    required this.p2,
    required this.p3,
  });

  final double height;
  final double width;
  final double p1; // start
  final double p2; // peak
  final double p3; // end

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  Path drawPath() {
    final path = Path();
    path.moveTo(widget.p1, widget.height);
    path.lineTo(widget.p2, 0);
    path.lineTo(widget.p3, widget.height);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      //size: Size(MediaQuery.of(context).size.width, widget.height),
      size: Size(widget.width, widget.height),
      painter: PathPainter(
        color: colorActive,
        path: drawPath(),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  Color color;
  PathPainter({required this.path, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // ..style = PaintingStyle.stroke
    //..strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
