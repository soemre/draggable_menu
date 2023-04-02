import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollableManager extends StatefulWidget {
  final Widget child;

  const ScrollableManager({
    super.key,
    required this.child,
  });

  @override
  State<ScrollableManager> createState() => _ScrollableManagerState();
}

class _ScrollableManagerState extends State<ScrollableManager> {
  ScrollController? _controller;
  bool isOverScrolling = false;
  Drag? drag;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _DisabledScrollBehavior(
        onControllerSet: (controller) {
          _controller = controller;
        },
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) => onDragStart(details),
        onVerticalDragUpdate: (details) => onDragUpdate(details),
        onVerticalDragEnd: (details) => onDragEnd(details),
        child: IgnorePointer(child: widget.child),
      ),
    );
  }

  onDragStart(DragStartDetails details) {
    isOverScrolling = false;
    drag = null;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta == null) return;
    if (isOverScrolling) {
      ScrollableManagerScope.of(context)
          .onDragUpdate
          ?.call(details.globalPosition.dy);
    } else if (drag != null) {
      drag!.update(details);
    } else {
      if (_controller?.position.atEdge == true) {
        if (details.primaryDelta!.sign > 0 &&
            _controller?.position.pixels ==
                _controller?.position.minScrollExtent) {
          isOverScrolling = true;
          ScrollableManagerScope.of(context)
              .onDragStart
              ?.call(details.globalPosition.dy);
          return;
        } else if (details.primaryDelta!.sign < 0 &&
            _controller?.position.pixels ==
                _controller?.position.maxScrollExtent) {
          isOverScrolling = true;
          ScrollableManagerScope.of(context)
              .onDragStart
              ?.call(details.globalPosition.dy);
          return;
        }
      }
      drag = _controller?.position.drag(DragStartDetails(), () {
        drag = null;
      });
    }
  }

  onDragEnd(DragEndDetails details) {
    drag?.end(details);
    if (isOverScrolling) {
      isOverScrolling = false;
      ScrollableManagerScope.of(context).onDragEnd?.call();
    }
  }
}

class _DisabledScrollBehavior extends ScrollBehavior {
  final Function(ScrollController controller)? onControllerSet;

  const _DisabledScrollBehavior({this.onControllerSet});

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (onControllerSet != null) {
      onControllerSet!(details.controller);
    }
    return child;
  }
}
