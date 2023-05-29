import 'package:flutter/material.dart';

class DraggableMenuLevel {
  final double height;

  const DraggableMenuLevel({required this.height});

  DraggableMenuLevel.ratio({required double ratio})
      : height = (ratio *
            (WidgetsBinding.instance.window.physicalSize.height -
                WidgetsBinding.instance.window.padding.top) /
            WidgetsBinding.instance.window.devicePixelRatio) {
    assert(
      (ratio <= 1 && ratio >= 0),
      "Ratio parameter must take a value between 0 and 1.",
    );
  }
}
