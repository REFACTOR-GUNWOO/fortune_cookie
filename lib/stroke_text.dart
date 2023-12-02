import 'dart:collection';

import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final double strokeWidth;
  final Color strokeColor;

  const StrokeText(
      {Key? key,
      required this.text,
      required this.textStyle,
      required this.textAlign,
      required this.strokeWidth,
      required this.strokeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle.copyWith(
          inherit: true,
          shadows:
              outlinedText(strokeColor: strokeColor, strokeWidth: strokeWidth)),
      textAlign: textAlign,
    );
  }

  static List<Shadow> outlinedText(
      {double strokeWidth = 2,
      Color strokeColor = Colors.black,
      int precision = 2}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor));
      }
    }
    return result.toList();
  }
}
