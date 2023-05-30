import 'dart:ui';

class DraggableMenuLevel {
  final double height;

  const DraggableMenuLevel({required this.height});

  DraggableMenuLevel.ratio({required double ratio})
      : height = (ratio *
            (PlatformDispatcher.instance.views.first.physicalSize.height -
                PlatformDispatcher.instance.views.first.padding.top) /
            PlatformDispatcher.instance.views.first.devicePixelRatio) {
    assert(
      (ratio <= 1 && ratio >= 0),
      "Ratio parameter must take a value between 0 and 1.",
    );
  }
}
