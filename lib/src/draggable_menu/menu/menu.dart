import 'package:draggable_menu/src/draggable_menu/menu/controller.dart';
import 'package:draggable_menu/src/draggable_menu/menu/custom_draggable_menu.dart';
import 'package:draggable_menu/src/draggable_menu/menu/draggable_menu_level.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui_formatter.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui/classic.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableMenu extends StatefulWidget {
  /// If it is `true`, the widget will be at its minimum height.
  ///
  /// By default, it is `false`.
  final bool? allowToShrink;

  /// This is the parameter to use the `expand` feature and to define a level. If you want a fixed height for the `Level 0`, provide a Level as well.
  ///
  /// Provide `DraggableMenuLevel` objects inside of it to create a level and customize its height.
  /// The lowest object you pass will be `Level 0` of the `Draggable Menu`'s level. You must provide at least two levels to use the `expand` feature.
  ///
  /// By default, `Level 0`'s height is `240` (Unlike the `DraggableMenuLevel`s, your widget's height can pass this value.).
  final List<DraggableMenuLevel>? levels;

  /// Adds a child inside the Draggable Menu's Default UI.
  final Widget child;

  /// You can use `DraggableMenuController` to control the `DraggableMenu` widget.
  ///
  /// Provide the `DraggableMenuController` to the `controller` parameter.
  /// And use one of the methods of the `DraggableMenuController` to control the `DraggableMenu` widget. For example:
  ///
  /// ```dart
  /// onTap: () => _controller.animateTo(1);
  /// ```
  final DraggableMenuController? controller;

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
  final Function(DraggableMenuStatus status, int level)? addStatusListener;

  /// Adds a listener to listen to its Menu Value.
  ///
  /// The `menuValue` value takes a value between `-1` and `1`.
  /// And the `0` value stands for the Menu's `minimized at level 0` position. The `1` value stands for the Menu's `expanded` position. The `-1` value stands for the Menu's `closed` position.
  ///
  /// The `levelValue` value takes a value between `-1` and `∞`. (For example, the `3` value is stands for the `Level 3`.)
  /// And the whole numbers stands for the Menu's levels. The `-1` value stands for the Menu's `closed` position.
  ///
  /// *To understand better the usage of the "Value Listeners",
  /// check out the [Draggable Menu Example](https://github.com/emresoysuren/draggable_menu/tree/main/example) app.*
  final Function(double menuValue, double? raw, double levelValue)?
      addValueListener;

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

  /// It specifies whether the Draggable Menu will run fast drag gestures when fast-dragged.
  ///
  /// By default, it is `true`.
  final bool? fastDrag;

  /// Specifies the Fast Drag Velocity of the Draggable Menu. That means it defines how many velocities will be the threshold to run fast-drag gestures.
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

  /// It specifies whether the Draggable Menu will close itself when it has been fast-dragged.
  ///
  /// By default, it is `true`.
  final bool? fastDragClose;

  /// It specifies whether the Draggable Menu will minimize itself when it has been fast-dragged and it's expanded.
  ///
  /// By default, it is `true`.
  final bool? fastDragMinimize;

  /// It specifies whether the Draggable Menu will expand when it has been fast-dragged and can be expandable.
  ///
  /// By default, it is `true`.
  final bool? fastDragExpand;

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
    this.fastDragClose,
    this.fastDragMinimize,
    this.fastDragExpand,
    this.levels,
    this.allowToShrink,
    this.controller,
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
  late final AnimationController _animationController;
  double _value = 0;
  late Ticker _ticker;
  final _widgetKey = GlobalKey();
  double? _boxHeight;
  Function()? currentAnimation;
  DraggableMenuStatus _status = DraggableMenuStatus.minimized;
  double _menuValue = 0;
  double? _ref;
  double? _init;
  double? _defH;
  double? _pos;
  int atLevel = 0;
  late bool willExpand;
  List<DraggableMenuLevel> levels = [];
  DraggableMenuLevel? defaultLevel;

  @override
  void initState() {
    super.initState();
    _controllerInit();
    _levelsInit();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 320),
    );
    _ticker = createTicker((elapsed) {
      setState(() {
        if (_value > 0) {
          _value = 0;
        }
        if (willExpand) {
          if (_boxHeight != null) {
            if (levels.last.height < _boxHeight!) {
              _boxHeight = levels.last.height;
              _notifyStatusListener(DraggableMenuStatus.expanded);
            }
          }
        }
        _notifyListeners();
      });
    });
    _ticker.start();
  }

  _controllerInit() {
    widget.controller?.init((int level) => animateTo(level));
    widget.controller?.addListener(() => setState(() {}));
  }

  _notifyListeners() {
    _checkStatus();
    _notifyValueListener();
  }

  double? _raw() {
    if (_defH == null) return null;
    return _value + (_boxHeight ?? _defH)!;
  }

  _notifyValueListener() {
    final double value = _getMenuValue();
    if (_menuValue == value) return;
    _menuValue = value;
    widget.addValueListener?.call(_menuValue, _raw(), _levelValue());
  }

  _notifyStatusListener(DraggableMenuStatus status) {
    if (_status == status) return;
    _status = status;
    widget.addStatusListener?.call(status, atLevel);
  }

  double _getMenuValue() {
    double value = 0;
    _defH ??= _widgetKey.currentContext?.size?.height;
    if (_boxHeight == null || _boxHeight == _defH) {
      if (_value != 0) {
        value = (_value / _defH!);
      }
    } else if (_boxHeight != null && levels.isNotEmpty && willExpand) {
      value = ((_boxHeight! - _defH!) / (levels.last.height - _defH!));
    }
    return value;
  }

  double _levelValue() {
    if (_value != 0) {
      return _getMenuValue();
    } else {
      return _menuValue * ((levels.length - 1) <= 0 ? 0 : (levels.length - 1));
    }
  }

  void _checkStatus() {
    if (_animationController.isAnimating ||
        _status == DraggableMenuStatus.closing) {
      return;
    }
    if (_defH == null) return;
    if (_value < 0) {
      if (widget.fixedCloseThreshold == null
          ? (-_value / _defH! > (widget.closeThreshold ?? (0.5)))
          : -_value > widget.fixedCloseThreshold!) {
        _notifyStatusListener(DraggableMenuStatus.willClose);
      } else {
        _notifyStatusListener(DraggableMenuStatus.mayClose);
      }
    } else if (!willExpand || (_boxHeight == null)) {
      _notifyStatusListener(DraggableMenuStatus.minimized);
    } else if (_boxHeight != null) {
      // Upper Part
      if (willExpand &&
          levels.isNotEmpty &&
          (_boxHeight! >= levels.last.height) &&
          (atLevel == (levels.length - 1))) {
        _notifyStatusListener(DraggableMenuStatus.expanded);
      } else {
        if (_boxHeight! < _levelHeight(atLevel)) {
          if (_levelHeight(atLevel) - _boxHeight! >
              (widget.fixedMinimizeThreshold == null
                  ? (_levelHeight(atLevel) - _levelHeight(atLevel - 1)) *
                      (widget.minimizeThreshold ?? (1 / 3))
                  : widget.fixedMinimizeThreshold!)) {
            _notifyStatusListener(DraggableMenuStatus.willMinimize);
          } else {
            _notifyStatusListener(DraggableMenuStatus.mayMinimize);
          }
        } else if (_boxHeight! > _levelHeight(atLevel)) {
          if (_boxHeight! - _levelHeight(atLevel) >
              (widget.fixedExpandThreshold == null
                  ? (_levelHeight(atLevel + 1) - _levelHeight(atLevel)) *
                      (widget.expandThreshold ?? (1 / 3))
                  : widget.fixedExpandThreshold!)) {
            _notifyStatusListener(DraggableMenuStatus.willExpand);
          } else {
            _notifyStatusListener(DraggableMenuStatus.mayExpand);
          }
        } else if (_boxHeight! == _levelHeight(atLevel)) {
          _notifyStatusListener(DraggableMenuStatus.minimized);
        }
      }
    }
  }

  void _levelsInit() {
    if (levels.isNotEmpty) levels.clear();
    if (widget.levels?.isNotEmpty == true) {
      for (DraggableMenuLevel level in widget.levels!) {
        if (!levels.any((element) => element.height == level.height)) {
          levels.add(level);
        }
      }
      levels.sort((a, b) => a.height.compareTo(b.height));
      defaultLevel = levels.first;
    }
    willExpand = (levels.isNotEmpty && levels.length > 1);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _animationController.dispose();
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
                maxHeight:
                    _boxHeight ?? defaultLevel?.height ?? double.infinity,
                minHeight: _boxHeight ??
                    (widget.allowToShrink == true
                        ? 0
                        : defaultLevel?.height ?? 240),
                child: widget.customUi ??
                    widget.ui?.buildUi(
                      context,
                      widget.child,
                      _status,
                      atLevel,
                      _menuValue,
                      _raw(),
                      _levelValue(),
                      widget.animationDuration ??
                          const Duration(milliseconds: 320),
                      widget.curve ?? Curves.ease,
                    ) ??
                    const ClassicDraggableMenu().buildUi(
                      context,
                      widget.child,
                      _status,
                      atLevel,
                      _menuValue,
                      _raw(),
                      _levelValue(),
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

  animateTo(int level) {
    assert(level < levels.length, "There is no level called Level $level.");
    atLevel = level;
    currentAnimation?.call();
    Animation<double> animation = Tween<double>(
      begin: _boxHeight ?? _defH,
      end: _levelHeight(level),
    ).animate(
      _animationController.drive(
        CurveTween(curve: widget.curve ?? Curves.ease),
      ),
    );
    callback() {
      if (_boxHeight != null) {
        if (_boxHeight! <= _defH!) {
          _boxHeight = null;
          return;
        }
      }
      _boxHeight = animation.value;
    }

    currentAnimation = () => animation.removeListener(callback);
    animation.addListener(callback);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_boxHeight != null) {
          if (_boxHeight! <= _defH!) {
            _boxHeight = null;
          }
        }
        if (_raw() == _levelHeight(level)) {
          if (_raw() != levels.last.height) {
            _notifyStatusListener(DraggableMenuStatus.minimized);
          } else {
            _notifyStatusListener(DraggableMenuStatus.expanded);
          }
        }
      }
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _minimize() {
    if ((_boxHeight ?? _defH) == _defH) return;
    _notifyStatusListener(DraggableMenuStatus.minimizing);
    animateTo(atLevel - 1);
  }

  void _expand() {
    if ((_boxHeight ?? _defH) == levels.last.height) return;
    _notifyStatusListener(DraggableMenuStatus.expanding);
    animateTo(atLevel + 1);
  }

  void _cancel() {
    if ((_boxHeight ?? _defH) == _levelHeight(atLevel)) return;
    _notifyStatusListener(DraggableMenuStatus.canceling);
    animateTo(atLevel);
  }

  onDragEnd(DragEndDetails details) {
    if (fastDrag(details)) return;
    if (_defH == null) return;
    if (_boxHeight == null) {
      if (widget.fixedCloseThreshold == null
          ? (-_value / _defH! > (widget.closeThreshold ?? (0.5)))
          : -_value > widget.fixedCloseThreshold!) {
        _close();
        return;
      }
      if (_value == 0) return;
      currentAnimation?.call();
      Animation<double> animation =
          Tween<double>(begin: _value, end: 0).animate(
        _animationController.drive(
          CurveTween(curve: widget.curve ?? Curves.ease),
        ),
      );
      callback() {
        _value = animation.value;
      }

      currentAnimation = () => animation.removeListener(callback);
      animation.addListener(callback);
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animation.removeListener(callback);
          if (_value == 0 && _boxHeight == null) {
            _notifyStatusListener(DraggableMenuStatus.minimized);
          }
        }
      });
      _animationController.reset();
      _notifyStatusListener(DraggableMenuStatus.canceling);
      _animationController.forward();
    } else {
      if (willExpand) {
        if ((_pos! > _levelHeight(atLevel)) && (_pos! <= levels.last.height)) {
          if (_pos! - _levelHeight(atLevel) >
              (widget.fixedExpandThreshold == null
                  ? (_levelHeight(atLevel + 1) - _levelHeight(atLevel)) *
                      (widget.expandThreshold ?? (1 / 3))
                  : widget.fixedExpandThreshold!)) {
            _expand();
          } else {
            _cancel();
          }
        } else if (_pos! < _levelHeight(atLevel)) {
          if (_levelHeight(atLevel) - _pos! >
              (widget.fixedMinimizeThreshold == null
                  ? (_levelHeight(atLevel) - _levelHeight(atLevel - 1)) *
                      (widget.minimizeThreshold ?? (1 / 3))
                  : widget.fixedMinimizeThreshold!)) {
            _minimize();
          } else {
            _cancel();
          }
        }
      } else {
        _cancel();
      }
    }
  }

  double _levelHeight(int level) {
    if (level == 0) return _defH!;
    return levels[level].height;
  }

  void onDragUpdate(double globalPosition) {
    if (_init == null || _ref == null || _defH == null || _pos == null) {
      return;
    }
    final double delta = _ref! - globalPosition;
    _pos = _init! + delta;
    if (_pos! > _defH!) {
      if (willExpand) {
        if (_pos! > levels.last.height) {
          if (_boxHeight != levels.last.height) _boxHeight = levels.last.height;
          _value = 0;
          _ref = globalPosition + (levels.last.height - _init!);
        } else {
          _boxHeight = _pos!;
          _value = 0;
        }
      } else {
        _boxHeight = null;
        _value = 0;
        _ref = globalPosition + (_defH! - _init!);
      }
    } else if (_pos! <= _defH!) {
      if (_boxHeight != null) _boxHeight = null;
      _value = _pos! - _defH!;
    }
    _checkLevel();
  }

  onDragStart(double globalPosition) {
    if (_animationController.isAnimating) _animationController.stop();
    _ref = globalPosition;
    _defH ??= _widgetKey.currentContext?.size?.height;
    _init = _value + (_boxHeight ?? _defH)!;
    _pos = _init;
  }

  bool fastDrag(DragEndDetails details) {
    if (widget.fastDrag == false) return false;
    if (widget.fastDragVelocity != null) {
      assert(
        widget.fastDragVelocity! >= 0,
        "The `fastDragVelocity` parameter can't be negative.",
      );
    }
    if (details.velocity.pixelsPerSecond.dy >
        (widget.fastDragVelocity ?? 1500)) {
      if ((widget.minimizeBeforeFastDrag == true && _boxHeight == null) ||
          (widget.minimizeBeforeFastDrag != true)) {
        if ((widget.fastDragClose != false)) {
          _close();
          return true;
        }
      } else if (widget.minimizeBeforeFastDrag == true && _boxHeight != null) {
        if (willExpand && (widget.fastDragMinimize != false)) {
          _minimize();
          return true;
        }
      }
    } else if (details.velocity.pixelsPerSecond.dy <
        -(widget.fastDragVelocity ?? 1500)) {
      if (atLevel != (levels.length - 1)) {
        if (willExpand && (widget.fastDragExpand != false)) {
          _expand();
          return true;
        }
      }
    }
    return false;
  }

  _close() {
    if (widget.blockMenuClosing == true) return;
    _notifyStatusListener(DraggableMenuStatus.closing);
    Navigator.pop(context);
  }

  void _checkLevel() {
    // Find the current level.
    // If it can't expand it must be at the level 0.
    if (_pos == null) return;
    if (_pos! < _levelHeight(0) || !willExpand) {
      if (atLevel != 0) atLevel = 0;
      return;
    }
    int cLevel = 0;
    for (int i = 0; i < levels.length; i++) {
      if (_pos! < _levelHeight(i)) break;
      cLevel = i;
    }
    if (atLevel > cLevel) {
      cLevel = cLevel + 1;
    }
    // Change the level status.
    if (atLevel == cLevel) return;
    atLevel = cLevel;
  }
}
