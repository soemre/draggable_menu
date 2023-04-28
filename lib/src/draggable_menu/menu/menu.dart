import 'package:draggable_menu/src/draggable_menu/menu/custom_draggable_menu.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui_formatter.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui/classic.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableMenu extends StatefulWidget {
  /// It specifies the min-height of the Draggable Menu.
  ///
  /// If the child's height is higher, it will take its child's height instead.
  final double? minHeight;

  /// It specifies the max-height of the Draggable Menu's minimized status (Not Expanded).
  ///
  /// When the menu is expanded, it takes its `expandedHeight` parameter's value as its height.
  ///
  /// To be able to use an expandable draggable menu, the `expandedHeight` parameter must be higher than the `maxHeight` parameter.
  final double? maxHeight;

  /// It specifies whether the Draggable Menu will be expandable or not.
  ///
  /// The `expandedHeight` parameter must be provided to use an expandable draggable menu.
  ///
  /// When the menu is expanded, it takes its `expandedHeight` parameter's value as its height.
  final bool? expandable;

  /// It specifies the height of the Draggable Menu when it's expanded.
  ///
  /// To be able to use an expandable draggable menu, the `expandedHeight` parameter must be higher than the `maxHeight` parameter,
  /// and the `expandable` parameter mustn't be null.
  final double? expandedHeight;

  /// Adds a child inside the Draggable Menu's Default UI.
  final Widget child;

  /// Overrides the Classic Draggable Menu UI.
  ///
  /// Thanks to the `ui` parameter, you can create your custom UI from scratch.
  ///
  /// Create a class that extends `CustomDraggableMenu` and overrides `CustomDraggableMenu`'s `buildUi` method.
  /// And return your UI inside of it.
  ///
  /// Or you can use pre-made UIs instead of creating from scratch.
  /// Pre-Made UIs:
  /// - `ClassicDraggableMenu`
  /// - `ModernDraggableMenu`
  /// - `SoftModernDraggableMenu`
  ///
  /// *Check out the [Draggable Menu Example](https://github.com/emresoysuren/draggable_menu/tree/main/example)
  /// app for more examples.*
  final CustomDraggableMenu? ui;

  /// Adds a listener to listen to its Status.
  ///
  /// *To understand better the usage of the "Status Listeners",
  /// check out the [Draggable Menu Example](https://github.com/emresoysuren/draggable_menu/tree/main/example) app.*
  final Function(DraggableMenuStatus status)? addStatusListener;

  /// Adds a listener to listen to its Menu Value.
  ///
  /// Takes a value between `-1` and `1`.
  ///
  /// The `0` value stands for the Menu's `minimized` position. The `1` value stands for the Menu's `expanded` position. The `-1` value stands for the Menu's `closed` position.
  ///
  /// *To understand better the usage of the "Value Listeners",
  /// check out the [Draggable Menu Example](https://github.com/emresoysuren/draggable_menu/tree/main/example) app.*
  final Function(double menuValue)? addValueListener;

  /// Specifies the duration of the Draggable Menu's animations.
  ///
  /// By default, it is `320ms`.
  final Duration? animationDuration;

  /// Specifies the curve of the Draggable Menu's animations.
  ///
  /// By default, it is `Curves.ease`.
  final Curve? curve;

  /// Specifies the Close Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `0.5`.
  final double? closeThreshold;

  /// Specifies the Close Threshold of the Draggable Menu by giving it a fixed value.
  ///
  /// If it is not `null`, it will bypass both the default and the parameter percentage thresholds.
  final double? fixedCloseThreshold;

  /// Specifies the Expand Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `1/3`.
  final double? expandThreshold;

  /// Specifies the Expand Threshold of the Draggable Menu by giving it a fixed value.
  ///
  /// If it is not `null`, it will bypass both the default and the parameter percentage thresholds.
  final double? fixedExpandThreshold;

  /// Specifies the Minimize Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `1/3`.
  final double? minimizeThreshold;

  /// Specifies the Minimize Threshold of the Draggable Menu by giving it a fixed value.
  ///
  /// If it is not `null`, it will bypass both the default and the parameter percentage thresholds.
  final double? fixedMinimizeThreshold;

  /// It specifies whether the Draggable Menu can close itself by dragging down and taping outside of the Menu or not.
  ///
  /// If it is `true`, it'll block closing the Draggable Menu by dragging down and taping outside.
  ///
  /// By default, it is `false`.
  final bool? blockMenuClosing;

  /// It specifies whether the Draggable Menu will be closed when it has been dragged too fast or not.
  ///
  /// By default, it is `true`.
  final bool? fastDrag;

  /// Specifies the Fast Drag Velocity of the Draggable Menu. That means it defines how many velocities will pop the menu.
  ///
  /// Takes a value above `0`. If the value is negative, it will throw an error.
  ///
  /// By default, it is `1500`.
  final double? fastDragVelocity;

  /// It specifies whether the Draggable Menu will be minimized when it has been dragged too fast or not when it's expanded.
  ///
  /// It'll only work if the `fastDrag` parameter has been set.
  ///
  /// By default, it is `false`.
  final bool? minimizeBeforeFastDrag;

  /// Overrides the Draggable Menu's UI and uses the widget given to the `customUi` parameter.
  ///
  /// If used, the `child` parameter of the `DraggableMenu` widget won't work.
  ///
  /// Prefer using the `ui` parameter if you want to create your UI.
  final Widget? customUi;

  /// Creates a Draggable Menu widget.
  ///
  /// To push the Draggable Menu to the screen, you can use the `DraggableMenu`'s `open` and `openReplacement` methods.
  ///
  /// ---
  ///
  /// #### Using Scrollables
  /// While using scrollable with a Draggable Menu you need to add the `ScrollableManager` widget
  /// above the scrollable you want to control Draggable with and set the physics of the Scrollable (e.g. ListView)
  /// to `NeverScrollableScrollPhysics`. The `ScrollableManager` widget must be under a `DraggableMenu` widget.
  /// You can do it by just simply using your widgets under its `child` parameter.
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
  /// In short, do not forget to use `ScrollableManager` and set the physics of
  /// the scrollable you want to `NeverScrollableScrollPhysics`.
  ///
  /// ---
  ///
  /// *For more info, visit the [GitHub Repository](https://github.com/emresoysuren/draggable_menu).*
  const DraggableMenu({
    super.key,
    this.minHeight,
    this.maxHeight,
    this.expandable,
    this.expandedHeight,
    required this.child,
    this.ui,
    this.addStatusListener,
    this.addValueListener,
    this.animationDuration,
    this.curve,
    this.closeThreshold,
    this.expandThreshold,
    this.minimizeThreshold,
    this.fixedCloseThreshold,
    this.fixedExpandThreshold,
    this.fixedMinimizeThreshold,
    this.blockMenuClosing,
    this.fastDrag,
    this.fastDragVelocity,
    this.minimizeBeforeFastDrag,
    this.customUi,
  });

  /// Opens the given Draggable Menu using `Navigator`'s `push` method.
  ///
  /// *The `DraggableMenu.open()` shouldn't be in the same place as the `MaterialApp` widget.*
  static Future<T?> open<T extends Object?>(
    BuildContext context,
    Widget draggableMenu, {
    Duration? animationDuration,
    Curve? curve,
    Curve? popCurve,
    bool? barrier,
    Color? barrierColor,
  }) =>
      Navigator.of(context).push<T>(
        MenuRoute<T>(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
          popCurve: popCurve,
          barrier: barrier,
          barrierColor: barrierColor,
        ),
      );

  /// Opens the given Draggable Menu using `Navigator`'s `pushReplacement` method.
  ///
  /// *The `DraggableMenu.openReplacement()` shouldn't be in the same place as the `MaterialApp` widget.*
  static Future openReplacement(
    BuildContext context,
    Widget draggableMenu, {
    Duration? animationDuration,
    Curve? curve,
    Curve? popCurve,
    bool? barrier,
    Color? barrierColor,
  }) =>
      Navigator.of(context).pushReplacement(
        MenuRoute(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
          popCurve: popCurve,
          barrier: barrier,
          barrierColor: barrierColor,
        ),
      );

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double _value = 0;
  double _valueStart = 0;
  double? _yAxisStart;
  late Ticker _ticker;
  final _widgetKey = GlobalKey();
  double? _currentHeight;
  double? _initHeight;
  bool _isExpanded = false;
  double? _currentHeightStart;
  int? currentAnimation;
  late final double? _expandedHeight;
  late bool willExpand;
  DraggableMenuStatus? _status;
  double _listenerValue = 0;
  double? minimizedHeight;

  @override
  void initState() {
    super.initState();
    _expandInit();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 320),
    );
    _ticker = createTicker((elapsed) {
      setState(() {
        if (_value > 0) {
          _value = 0;
          _valueStart = 0;
        }
        if (willExpand) {
          if (_currentHeight != null) {
            if (_expandedHeight! < _currentHeight!) {
              _currentHeight = _expandedHeight;
              _currentHeightStart = _expandedHeight;
              if (!_isExpanded) _isExpanded = true;
              _notifyStatusListener(DraggableMenuStatus.expanded);
            }
          }
        }
        _notifyValueListener();
      });
    });
    _ticker.start();
  }

  _notifyValueListener() {
    double value = 0;
    minimizedHeight ??= _widgetKey.currentContext?.size?.height;
    if (minimizedHeight == null) return;
    if (_currentHeight == null || _currentHeight == minimizedHeight) {
      if (_value != 0) {
        value = (_value / minimizedHeight!);
      }
    } else if (_currentHeight != null) {
      value = ((_currentHeight! - minimizedHeight!) /
          (widget.expandedHeight! - minimizedHeight!));
    }
    if (_listenerValue == value) return;
    _listenerValue = value;
    if (widget.addValueListener != null) {
      widget.addValueListener!(_listenerValue);
    }
  }

  _notifyStatusListener(DraggableMenuStatus status) {
    if (_status == status) return;
    _status = status;
    if (widget.addStatusListener != null) widget.addStatusListener!(status);
  }

  void _expandInit() {
    if (widget.expandable == true) {
      willExpand = true;
      // willExpand shouldn't be true if _expandedHeight is null!
      if (widget.expandedHeight != null) {
        if (widget.maxHeight != null) {
          if (widget.expandedHeight! > widget.maxHeight!) {
            _expandedHeight = widget.expandedHeight!;
          } else {
            willExpand = false;
          }
        } else {
          _expandedHeight = widget.expandedHeight!;
        }
      } else {
        if (widget.maxHeight != null) {
          _expandedHeight = widget.maxHeight!;
        } else {
          willExpand = false;
        }
      }
    } else {
      willExpand = false;
    }
  }

  @override
  void didUpdateWidget(covariant DraggableMenu oldWidget) {
    if (oldWidget.expandable != widget.expandable) {
      _expandInit();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) => onDragStart(details.globalPosition.dy),
      onVerticalDragUpdate: (details) =>
          onDragUpdate(details.globalPosition.dy),
      onVerticalDragEnd: (details) => onDragEnd(details),
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              _close();
            },
            child: const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            key: _widgetKey,
            bottom: _value,
            child: ScrollableManagerScope(
              status: _status,
              willExpand: willExpand,
              onDragStart: (globalPosition) => onDragStart(globalPosition),
              onDragUpdate: (globalPosition) => onDragUpdate(globalPosition),
              onDragEnd: (details) => onDragEnd(details),
              child: UiFormatter(
                minHeight: _currentHeight ?? widget.minHeight ?? 240,
                maxHeight:
                    _currentHeight ?? widget.maxHeight ?? double.infinity,
                child: widget.customUi ??
                    widget.ui?.buildUi(
                      context,
                      widget.child,
                      _status,
                      _listenerValue,
                      widget.animationDuration ??
                          const Duration(milliseconds: 320),
                      widget.curve ?? Curves.ease,
                    ) ??
                    const ClassicDraggableMenu().buildUi(
                      context,
                      widget.child,
                      _status,
                      _listenerValue,
                      widget.animationDuration ??
                          const Duration(milliseconds: 320),
                      widget.curve ?? Curves.ease,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _closeExpanded() {
    _isExpanded = false;
    currentAnimation = 2;
    Animation<double> animation =
        Tween<double>(begin: _currentHeight, end: _initHeight).animate(
      _controller.drive(
        CurveTween(curve: widget.curve ?? Curves.ease),
      ),
    );
    callback() {
      if (currentAnimation == 2) {
        if (_currentHeight != _initHeight) {
          _currentHeight = animation.value;
          _currentHeightStart = _currentHeight;
        } else {
          _currentHeight = null;
          _currentHeightStart = null;
        }
      }
    }

    animation.addListener(callback);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.removeListener(callback);
        if (_currentHeight == _initHeight) {
          _currentHeight = null;
          _currentHeightStart = null;
        }
        if (_value == 0 && _currentHeight == null) {
          _notifyStatusListener(DraggableMenuStatus.minimized);
        }
      }
    });
    _controller.reset();
    _notifyStatusListener(DraggableMenuStatus.minimizing);
    _controller.forward();
  }

  void _openExpanded() {
    _isExpanded = true;
    currentAnimation = 3;

    Animation<double> animation =
        Tween<double>(begin: _currentHeight, end: _expandedHeight).animate(
      _controller.drive(
        CurveTween(curve: widget.curve ?? Curves.ease),
      ),
    );
    callback() {
      if (currentAnimation == 3) {
        _currentHeight = animation.value;
        _currentHeightStart = _currentHeight;
      }
    }

    animation.addListener(callback);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.removeListener(callback);
        if (_currentHeight == _expandedHeight) {
          _notifyStatusListener(DraggableMenuStatus.expanded);
        }
      }
    });
    _controller.reset();
    _notifyStatusListener(DraggableMenuStatus.expanding);
    _controller.forward();
  }

  onDragEnd(DragEndDetails details) {
    if (widget.fastDrag != false && fastDrag(details)) return;
    final double? widgetHeight = _widgetKey.currentContext?.size?.height;
    if (widgetHeight == null) return;
    if (_currentHeight == null) {
      if (widget.fixedCloseThreshold == null
          ? (-_value / widgetHeight > (widget.closeThreshold ?? (0.5)))
          : -_value > widget.fixedCloseThreshold!) {
        _close();
        return;
      }
      currentAnimation = 1;
      Animation<double> animation =
          Tween<double>(begin: _value, end: 0).animate(
        _controller.drive(
          CurveTween(curve: widget.curve ?? Curves.ease),
        ),
      );
      callback() {
        if (currentAnimation == 1) {
          _value = animation.value;
          _valueStart = _value;
        }
      }

      animation.addListener(callback);
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animation.removeListener(callback);
          if (_value == 0 && _currentHeight == null) {
            _notifyStatusListener(DraggableMenuStatus.minimized);
          }
        }
      });
      _controller.reset();
      _notifyStatusListener(DraggableMenuStatus.canceling);
      _controller.forward();
    } else {
      if (willExpand) {
        if (_isExpanded == false) {
          if (_currentHeight! - _initHeight! >
              (widget.fixedExpandThreshold == null
                  ? (_expandedHeight! - _initHeight!) *
                      (widget.expandThreshold ?? (1 / 3))
                  : widget.fixedExpandThreshold!)) {
            _openExpanded();
          } else {
            _closeExpanded();
          }
        } else {
          if (_expandedHeight! - _currentHeight! >
              (widget.fixedMinimizeThreshold == null
                  ? (_expandedHeight! - _initHeight!) *
                      (widget.minimizeThreshold ?? (1 / 3))
                  : widget.fixedMinimizeThreshold!)) {
            _closeExpanded();
          } else {
            _openExpanded();
          }
        }
      } else {
        _closeExpanded();
      }
    }
  }

  void onDragUpdate(double globalPosition) {
    if (_yAxisStart == null) return;
    double valueChange = _yAxisStart! - globalPosition;
    if (_value == 0 && valueChange > 0) {
      if (globalPosition < _valueStart) return;
      if (willExpand) {
        if (_expandedHeight! > (_currentHeight ?? _initHeight!)) {
          _currentHeight = (_currentHeightStart ?? _initHeight!) + valueChange;
          _notifyStatusListener(DraggableMenuStatus.mayExpand);
        } else {
          // Opens the expanded feat
          if (!_isExpanded) {
            _currentHeight = _expandedHeight;
            _currentHeightStart = _expandedHeight;
            _isExpanded = true;
            _notifyStatusListener(DraggableMenuStatus.expanded);
          }
          _yAxisStart = globalPosition - _valueStart;
        }
      } else {
        _yAxisStart = globalPosition - _valueStart;
      }
    } else {
      if (_currentHeight != null) {
        if (_currentHeight! > _initHeight!) {
          _currentHeight = (_currentHeightStart ?? _initHeight!) + valueChange;
          _notifyStatusListener(DraggableMenuStatus.mayMinimize);
        } else {
          _currentHeight = null;
          _currentHeightStart = null;
          _isExpanded = false;
          _yAxisStart = globalPosition;
          _notifyStatusListener(DraggableMenuStatus.minimized);
        }
      } else {
        _value = _valueStart + valueChange;
        _notifyStatusListener(DraggableMenuStatus.mayClose);
      }
    }
  }

  onDragStart(double globalPosition) {
    if (_controller.isAnimating) _controller.stop();
    _yAxisStart = globalPosition;
    _initHeight ??= _widgetKey.currentContext?.size?.height;
  }

  bool fastDrag(DragEndDetails details) {
    if (widget.fastDragVelocity != null) {
      assert(widget.fastDragVelocity! >= 0,
          "The `fastDragVelocity` parameter can't be negative.");
    }
    if (details.velocity.pixelsPerSecond.dy >
        (widget.fastDragVelocity ?? 1500)) {
      if ((widget.minimizeBeforeFastDrag == true && _currentHeight == null) ||
          (widget.minimizeBeforeFastDrag == false)) {
        _close();
        return true;
      }
    }
    return false;
  }

  _close() {
    if (widget.blockMenuClosing == true) return;
    _notifyStatusListener(DraggableMenuStatus.closing);
    Navigator.pop(context);
  }
}
