import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isMobileApp() {
  if (kIsWeb) return false; // not sure if needed
  return (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS);
}

bool isTabletOrDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > 768;
}
