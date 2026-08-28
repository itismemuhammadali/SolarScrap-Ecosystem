import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? child;
  final Color? textColor;
  final bool isEnabled;

  const AppButton({
    super.key,
    this.text = '',
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 16,
    this.child,
    this.textColor,
    this.isEnabled = true,
  });

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00A63E),
      Color(0xFF007D2E),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final active = isEnabled && onPressed != null;

    return Opacity(
      opacity: active ? 1.0 : 0.5,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: greenGradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.zero,
          ),
          child: child ??
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
        ),
      ),
    );
  }
}
