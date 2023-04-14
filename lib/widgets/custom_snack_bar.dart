import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String message,
    super.behavior = SnackBarBehavior.floating,
    required EdgeInsets margin,
    Color? backgroundColor,
    TextStyle? textStyle,
    Duration duration = const Duration(seconds: 2),
  }) : super(
          key: key,
          backgroundColor: backgroundColor,
          duration: duration,
          content: Row(
            children: [
              const Icon(
                LineIcons.infoCircle,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
}
