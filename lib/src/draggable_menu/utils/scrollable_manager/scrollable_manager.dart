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

  /// The `controller` parameter allows you to use a `ScrollController` with the scrollable under it.
  final ScrollController? controller;

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
    this.controller,
  });

  @override
  State<ScrollableManager> createState() => _ScrollableManagerState();
}

class _ScrollableManagerState extends State<ScrollableManager> {
  late final ScrollController _controller =
      widget.controller ?? ScrollController();
  bool isOverScrolling = false;
  Drag? drag;

  ScrollableManagerScope get _manager => ScrollableManagerScope.of(context);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _controller,
      child: ScrollConfiguration(
        behavior: const _DisabledScrollBehavior(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: (details) => onDragStart(details),
          onVerticalDragUpdate: (details) => onDragUpdate(details),
          onVerticalDragEnd: (details) => onDragEnd(details),
          child: widget.child,
        ),
      ),
    );
  }

  onDragStart(DragStartDetails details) {
    _throwIf();
    isOverScrolling = false;
    drag = null;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta == null) return;
    if (isOverScrolling) {
      _manager.onDragUpdate.call(details.globalPosition.dy);
    } else if (drag != null) {
      drag!.update(details);
    } else {
      if ((widget.enableExpandedScroll != true) ||
          (_manager.canExpand != true)) {
        _handleStart(details);
      } else {
        // if enableExpandedScroll == true
        if (_manager.status == DraggableMenuStatus.expanded) {
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
      _manager.onDragEnd.call(details);
    }
  }

  void _handleStart(DragUpdateDetails details) {
    if (_controller.position.atEdge == true) {
      if (details.primaryDelta!.sign > 0 &&
          _controller.position.pixels == _controller.position.minScrollExtent) {
        _startOverScrolling(details);
        return;
      } else if (details.primaryDelta!.sign < 0 &&
          _controller.position.pixels == _controller.position.maxScrollExtent) {
        _startOverScrolling(details);
        return;
      }
    }
    drag = _controller.position.drag(DragStartDetails(), () {
      drag = null;
    });
  }

  void _startOverScrolling(DragUpdateDetails details) {
    isOverScrolling = true;
    _manager.onDragStart.call(details.globalPosition.dy);
  }

  _throwIf() {
    assert(_controller.hasClients,
        "The Scrollable Manager widget should be attached with a scrollable. Be sure you use one scrollable widget under it, and do not use any scroll controllers with the scrollable widget. If you want to use a scroll controller, give the controller to ScrollManager's controller parameter instead.");
  }
}

class _DisabledScrollBehavior extends ScrollBehavior {
  const _DisabledScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
