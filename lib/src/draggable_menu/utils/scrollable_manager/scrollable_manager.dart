import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollableManager extends StatefulWidget {
  /// Prefer using this just above scrollables.
  ///
  /// Do not forget to set the physics of the scrollable to `NeverScrollableScrollPhysics`.
  ///
  /// If there will be more than one `ScrollableManager` at the same time, give each scrollables different controllers.
  final Widget child;

  /// Only work if the `DraggableMenu`'s expandable feature can work.
  ///
  /// If it can work, it will block its scrollable child's drag-up gesture when the Draggable Menu's status isn't `expanded`.
  ///
  /// By default, it is `false`.
  final bool? enableExpandedScroll;

  /// Prefer using this just above scrollables.
  ///
  /// Do not forget to set the physics of the scrollable to `NeverScrollableScrollPhysics`.
  ///
  /// If there will be more than one `ScrollableManager` at the same time, give each scrollables different controllers.
  ///
  /// ---
  ///
  /// #### Using Scrollables
  /// While using scrollable with a Draggable Menu you need to add the `ScrollableManager` widget
  /// above the scrollable you want to control Draggable with and set the physics of the Scrollable (e.g. ListView)
  /// to `NeverScrollableScrollPhysics`. The `ScrollableManager` widget must be under a `DraggableMenu` widget.
  /// You can do it by just simply using your widgets under its `child` or `customUI` parameters.
  ///
  /// ```dart
  /// DraggableMenu(
  ///   child: ScrollableManager(
  ///     child: ListView(
  ///       physics: const NeverScrollableScrollPhysics(),
  ///     ), // You can use any scrollable widget
  ///   ),
  /// )
  /// ```
  ///
  /// ---
  ///
  /// The `enableExpandedScroll` parameter blocks its scrollable child's drag-up gesture
  /// when the Draggable Menu's status isn't `expanded`. (By default, it is `false`.)
  const ScrollableManager({
    super.key,
    required this.child,
    this.enableExpandedScroll,
  });

  @override
  State<ScrollableManager> createState() => _ScrollableManagerState();
}

class _ScrollableManagerState extends State<ScrollableManager> {
  ScrollController? _controller;
  bool isOverScrolling = false;
  Drag? drag;

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
        child: widget.child,
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
      if ((widget.enableExpandedScroll != true) ||
          (ScrollableManagerScope.of(context).willExpand != true)) {
        _handleStart(details);
      } else {
        // if enableExpandedScroll == true
        if (ScrollableManagerScope.of(context).status ==
            DraggableMenuStatus.expanded) {
          _handleStart(details);
        } else {
          if (details.primaryDelta!.sign < 0) {
            _startOverScrolling(details);
          } else {
            _handleStart(details);
          }
        }
      }
    }
  }

  onDragEnd(DragEndDetails details) {
    drag?.end(details);
    if (isOverScrolling) {
      isOverScrolling = false;
      ScrollableManagerScope.of(context).onDragEnd?.call();
    }
  }

  void _handleStart(DragUpdateDetails details) {
    if (_controller?.position.atEdge == true) {
      if (details.primaryDelta!.sign > 0 &&
          _controller?.position.pixels ==
              _controller?.position.minScrollExtent) {
        _startOverScrolling(details);
        return;
      } else if (details.primaryDelta!.sign < 0 &&
          _controller?.position.pixels ==
              _controller?.position.maxScrollExtent) {
        _startOverScrolling(details);
        return;
      }
    }
    drag = _controller?.position.drag(DragStartDetails(), () {
      drag = null;
    });
  }

  void _startOverScrolling(DragUpdateDetails details) {
    isOverScrolling = true;
    ScrollableManagerScope.of(context)
        .onDragStart
        ?.call(details.globalPosition.dy);
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
