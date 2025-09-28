import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LogoStyle { text }

class Logo extends StatelessWidget {
  final LogoStyle style;
  final double height;

  const Logo({super.key, this.style = LogoStyle.text, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_text.svg',
      height: height,
      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
      semanticsLabel: 'Body.build logo',
    );
  }
}
