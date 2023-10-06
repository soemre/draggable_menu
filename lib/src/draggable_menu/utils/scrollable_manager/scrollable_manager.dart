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
  final bool enableExpandedScroll;

  /// Scrolls the scrollable as soon as the `DraggableMenu` reaches to the top.
  final bool smoothScrolling;

  /// The `controller` parameter allows you to use a `ScrollController` with the scrollable under it.
  final ScrollController? controller;

  /// Manages scrollables compatible with `DraggableMenu` widget.
  ///
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
    this.enableExpandedScroll = false,
    this.controller,
    this.smoothScrolling = false,
  });

  @override
  State<ScrollableManager> createState() => _ScrollableManagerState();
}

class _ScrollableManagerState extends State<ScrollableManager> {
  /// Stores the scroll controller.
  ///
  /// This controller will serve as the primary scroll controller for the scrollable widget
  /// under it. You don't need to pass the controller to the scrollable manager separately.
  late final ScrollController _controller =
      widget.controller ?? ScrollController();

  /// Whether the scrollable being overscrolled or not.
  bool _isOverScrolling = false;

  /// Stores the current drag activity to manage the scrollables.
  Drag? _drag;

  /// Looks up for the `ScrollableManagerScope` inherited widget
  /// to contoller and access the variables of the `DraggableMenu` widget.
  ScrollableManagerScope get _manager => ScrollableManagerScope.of(context);

  @override
  void dispose() {
    // Dispose the scroll controller.
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
          onVerticalDragStart: (details) => _onDragStart(details),
          onVerticalDragUpdate: (details) => _onDragUpdate(details),
          onVerticalDragEnd: (details) => _onDragEnd(details),
          child: widget.child,
        ),
      ),
    );
  }

  /// Handels the drag start event.
  ///
  /// Initilizes the needed variables to their start values.
  _onDragStart(DragStartDetails details) {
    assert(_controller.hasClients,
        "The Scrollable Manager widget should be attached with a scrollable. Be sure you use one scrollable widget under it, and do not use any scroll controllers with the scrollable widget. If you want to use a scroll controller, give the controller to ScrollManager's controller parameter instead.");
    _isOverScrolling = false;
    _drag = null;
  }

  /// Handels the drag update event.
  ///
  /// If the scrollable being overscrolled, moves the `DraggableMenu` widget.
  /// If it's not, moves the scrollable.
  ///
  /// If the drag behavior not initilized yet, start
  /// and assign a new Drag behavior to the `_drag` variable.
  ///
  /// If `enableExpandedScroll` is set to `true` of the `DraggableMenu` widget
  /// and there is enough levels for widget to expand itself,
  /// move the `DraggableMenu` widget when dragging up until it reaches the top level.
  _onDragUpdate(DragUpdateDetails details) {
    // If there is no change returns immediately.
    if (details.primaryDelta == null) return;

    if (_isOverScrolling) {
      // Smooth Scrolling
      if (widget.smoothScrolling &&
          _manager.status == DraggableMenuStatus.expanded &&
          details.primaryDelta!.sign < 0) {
        _isOverScrolling = false;
        _handleStart(details);
        return;
      }
      // Moves the `DraggableMenu` widget.
      _manager.onDragUpdate.call(details.globalPosition.dy);
    } else if (_drag != null) {
      // Smooth Scrolling
      if (widget.smoothScrolling) {
        if (_startEdgeOverscrolling(details)) {
          _drag?.cancel();
          _drag = null;
          return;
        }
      }

      // Moves the scrollable.
      _drag!.update(details);
    } else {
      // Drag event isn't started and assigned to the `_drag` variable.
      if (!widget.enableExpandedScroll || !_manager.canExpand) {
        // There is no need to move the `DraggableMenu` widget,
        // therefore start draging the scrollable.
        _handleStart(details);
      } else {
        // If `enableExpandedScroll` is set to `true` and the `DraggableMenu` can expand itself.
        if (_manager.status == DraggableMenuStatus.expanded) {
          // If it is expanded already start dragging to scrollable.
          _handleStart(details);
        } else {
          if (details.primaryDelta!.sign < 0) {
            // Drag the `DraggableMenu` widget.
            _startOverScrolling(details);
          } else {
            // Start draging the scrollable.
            _handleStart(details);
          }
        }
      }
    }
  }

  /// Handels the drag end event.
  ///
  /// Ends the drag event.
  ///
  /// Sets the `_isOverScrolling` variable to its start value.
  ///
  /// And if the `_isOverScrolling` is `true`,
  /// calls the `DraggableMenu`'s onDragEnd method to end the ui's movement ass well.
  _onDragEnd(DragEndDetails details) {
    _drag?.end(details);
    if (_isOverScrolling) {
      _isOverScrolling = false;
      _manager.onDragEnd.call(details);
    }
  }

  /// Starts a new drag event and assigns it to the scrollable.
  ///
  /// If the scrollable at its min or max scroll extents,
  /// starts moving the `DraggableMenu` widget
  /// instead of trying to scroll the scrollable out of it's extents.
  void _handleStart(DragUpdateDetails details) {
    if (_startEdgeOverscrolling(details)) return;

    // Starts the drag event and assigns it to the `_drag` variable.
    _drag = _controller.position.drag(DragStartDetails(), () {
      _drag = null;
    });
  }

  /// Does certain tasks to start overscrolling.
  ///
  /// Assigns the `_isOverScrolling` variable to `true`.
  /// And starts the `DraggableMenu`'s movement.
  void _startOverScrolling(DragUpdateDetails details) {
    _isOverScrolling = true;

    // To move the `DraggableMenu` widget.
    _manager.onDragStart.call(details.globalPosition.dy);
  }

  /// Moves the `DraggableMenu` widget if the scrollable is being overscrolled.
  ///
  /// Returns true if the current conditions suits overscrolling.
  bool _startEdgeOverscrolling(DragUpdateDetails details) {
    if (_controller.position.atEdge == true) {
      if (details.primaryDelta!.sign > 0 &&
          _controller.position.pixels == _controller.position.minScrollExtent) {
        _startOverScrolling(details);
        return true;
      } else if (details.primaryDelta!.sign < 0 &&
          _controller.position.pixels == _controller.position.maxScrollExtent) {
        _startOverScrolling(details);
        return true;
      }
    }
    return false;
  }
}

class _DisabledScrollBehavior extends ScrollBehavior {
  /// Removes the overscrolling animations.
  const _DisabledScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
