import 'package:flutter/material.dart';

class RTLHelper {
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  static Widget backIcon(BuildContext context, {Color? color, double size = 20}) {
    return Transform.scale(
      scaleX: isRTL(context) ? -1 : 1,
      child: Icon(Icons.arrow_back, color: color, size: size),
    );
  }

  static Widget chevronIcon(BuildContext context, {Color? color, double size = 18}) {
    return Transform.scale(
      scaleX: isRTL(context) ? -1 : 1,
      child: Icon(Icons.chevron_right, color: color, size: size),
    );
  }

  static Widget forwardIcon(BuildContext context, {Color? color, double size = 20}) {
    return Transform.scale(
      scaleX: isRTL(context) ? -1 : 1,
      child: Icon(Icons.arrow_forward_ios, color: color, size: size),
    );
  }
}
