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
  final bool allowToShrink;

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
  final bool blockMenuClosing;

  /// It specifies whether the Draggable Menu will run fast drag gestures when fast-dragged.
  ///
  /// By default, it is `true`.
  final bool fastDrag;

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
  final bool minimizeBeforeFastDrag;

  /// Overrides the Draggable Menu's UI and uses the widget given to the `customUi` parameter.
  ///
  /// If used, the `child` parameter of the `DraggableMenu` widget won't work.
  ///
  /// Prefer using the `ui` parameter if you want to create your UI.
  final Widget? customUi;

  /// It specifies whether the Draggable Menu will close itself when it has been fast-dragged.
  ///
  /// By default, it is `true`.
  final bool fastDragClose;

  /// It specifies whether the Draggable Menu will minimize itself when it has been fast-dragged and it's expanded.
  ///
  /// By default, it is `true`.
  final bool fastDragMinimize;

  /// It specifies whether the Draggable Menu will expand when it has been fast-dragged and can be expandable.
  ///
  /// By default, it is `true`.
  final bool fastDragExpand;

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
    this.blockMenuClosing = false,
    this.fastDrag = true,
    this.fastDragVelocity,
    this.minimizeBeforeFastDrag = false,
    this.customUi,
    this.fastDragClose = true,
    this.fastDragMinimize = true,
    this.fastDragExpand = true,
    this.levels,
    this.allowToShrink = false,
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
  // VARIBLES | START

  // FOR ANIMATION
  late final AnimationController _animationController;
  late Ticker _ticker;
  Function()? _removeLastAnimation;

  // MENU VALUES
  double? _boxHeight;
  double _bottom = 0;
  int _currentLevel = 0;
  double? _defaultHeight;
  List<DraggableMenuLevel> levels = [];
  final _widgetKey = GlobalKey();

  // MOVEMENT VALUES
  double? _startPosition;
  double? _startValue;

  // STATUS VALUES
  DraggableMenuStatus _status = DraggableMenuStatus.minimized;

  // VARIBLES | END

  // FUNCTIONAL METHODS | START

  // INIT

  void _defaultHeightInit() =>
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // SET THE CURRENT HEIGHT AS DEFAULT HEIGHT BEFORE IT CHANGES
        _defaultHeight = _widgetKey.currentContext!.size!.height;
      });

  void _controllerInit() {
    // INITILIZES THE CONTROLLER (PASSES THE ANIMETTO METHOD)
    widget.controller?.init((int level) => _animateTo(level));

    // LISTENS THE CONTROLLER
    widget.controller?.addListener(() => setState(() {}));
  }

  void _levelsInit() {
    // CHECK IF THERE IS ANY LEVEL GIVEN TO THE LEVELS PARAMETER
    if (widget.levels?.isNotEmpty == true) {
      // DO NOT ADD THE LEVELS WITH SAME HEIGHT
      for (DraggableMenuLevel level in widget.levels!) {
        if (!levels.any((element) => element.height == level.height)) {
          levels.add(level);
        }
      }

      // SORTS THE LEVELS WITH THEIR HEIGHTS
      levels.sort((a, b) => a.height.compareTo(b.height));
    }
  }

  // ASSIGN THE ANIMATION CONTROLLER TO THE VARIBLE
  void _animationControllerInit() => _animationController =
      AnimationController(vsync: this, duration: _animationDuraiton);

  void _tickerInit() {
    // CREATE THE TICKER AND ASSIGN IT TO THE VARIBLE
    _ticker = createTicker((_) {
      setState(() {
        // DEBUG BEFORE DISPLAY THE NEW STATE
        _debug();

        // NOTIFY THE LISTENERS BEFORE DISPLAY THE NEW STATE
        _notifyListeners();
      });
    });

    // START THE TICKER
    _ticker.start();
  }

  // DEBUG

  void _debug() {
    // DEBUG THE BOTTOM VALUE
    if (_bottom > 0) _bottom = 0;

    // DEBUG THE BOXHEIGHT VALUE
    if (_boxHeight != null) {
      if (_lastLevelHeight < _boxHeight!) {
        // CANNOT BE HEIGHER THE LAST LEVEL
        _boxHeight = _lastLevelHeight;
        _notifyStatusListener(DraggableMenuStatus.expanded);
      } else if (_boxHeight! <= _levelHeight(0)) {
        // VALUE CANNOT BE EQUAL OR LOWER THAN THE LEVEL 0
        _boxHeight = null;
      }
    }
  }

  // LISTENERS

  void _notifyListeners() {
    // CHECK THE STATUS AND NOTIFY ITS LISTENERS
    _checkStatus();

    // NOTIFY THE LOSTENERS WITH NEW VALUES
    _notifyValueListener();
  }

  // NOTIFIES THE VALUE LISTENERS
  _notifyValueListener() =>
      widget.addValueListener?.call(_menuValue, _value, _levelValue);

  // ANIMATETO METHOD

  void _animateTo(int level) {
    // ASSERT THE GIVEN LEVEL IS VALID
    _assertLevel(level);

    // SET THE GIVEN LEVEL AS THE CURRENT LEVEL
    _currentLevel = level;

    // REMOVE THE LAST ANIMATIONS LISTENER IF IT'S STILL LISTENING
    _removeLastAnimation?.call();

    // ASSIGN THE ANIMATION AND CALLBACK VALUES

    final Animation<double> animation =
        Tween<double>(begin: _value, end: _levelHeight(level)).animate(
      _animationController.drive(CurveTween(curve: _animationCurve)),
    );
    // REFLECT TO THE VALUE CHANGES
    void callback() {
      if (animation.value <= _levelHeight(0)) {
        _bottom = animation.value - _levelHeight(0);
        _boxHeight = null;
      } else {
        _bottom = 0;
        _boxHeight = animation.value;
      }
    }

    // STORE THE REMOVE LISTENER CALLBACK
    _removeLastAnimation = () => animation.removeListener(callback);

    // ADD CALLBACK AS THE LISTENER
    animation.addListener(callback);

    // RUN THE ANIMATION
    _animationController.reset();
    _animationController.forward();
  }

  // DEFAULT ANIMATE METHODS
  void _minimize() {
    // IF ITS HEIGHT IS NOT BIGGER THAN THE LEVEL 0 DO NOT TRY TO MINIMIZE IT
    if (!_atUpperPart) return;

    // MINIMIZE
    _notifyStatusListener(DraggableMenuStatus.minimizing);
    _animateTo(_currentLevel - 1);
  }

  void _expand() {
    // IF IT IS ALREADY EXPANDED. DON'T TRY TO EXPAND IT
    if (_isExpanded) return;

    // EXPAND
    _notifyStatusListener(DraggableMenuStatus.expanding);
    _animateTo(_currentLevel + 1);
  }

  void _cancel() {
    // IF IT IS ALREADY STABLE. DON'T TRY TO STABILIZE IT
    if (_isStable) return;

    // CANCEL (STABILIZE)
    _notifyStatusListener(DraggableMenuStatus.canceling);
    _animateTo(_currentLevel);
  }

  void _close() {
    // THE blockMenuClosing PARAMETER WILL CANCEL THE OPERATION
    if (widget.blockMenuClosing) return _cancel();

    // CLOSE
    _notifyStatusListener(DraggableMenuStatus.closing);
    Navigator.pop(context);
  }

  // FAST DRAG
  bool _fastDrag(DragEndDetails details) {
    // CHECK THE WIDGET PARAMETERS
    if (!widget.fastDrag) return false;
    assert(
      !_fastDragVelocity.isNegative,
      "The `fastDragVelocity` parameter can't be negative.",
    );

    // OPERATION
    final double velocity = details.velocity.pixelsPerSecond.dy;
    if (velocity > _fastDragVelocity) {
      // FAST DRAGGING TO DOWN
      if ((_minimizeBeforeFastDrag && _boxHeight == null) ||
          !_minimizeBeforeFastDrag) {
        // UNDER THE LEVEL 0 OR WILL CLOSE WHEN DRAG FAST
        if (widget.fastDragClose) {
          _close();
          return true;
        }
      } else if (_minimizeBeforeFastDrag && _boxHeight != null) {
        // ABOVE THE LEVEL 0
        if (widget.fastDragMinimize) {
          _minimize();
          return true;
        }
      }
    } else if (velocity < -_fastDragVelocity) {
      // FAST DRAGGING TO UP
      // CANNOT BE AT THE LAST LEVEL
      if (!_atMaxLevel && widget.fastDragExpand) {
        _expand();
        return true;
      }
    }
    return false;
  }

  /// Converts ghost value to _value and _boxHeight
  void _convertGhost(double ghostValue, double position) {
    assert(_startValue != null);

    if (ghostValue <= _levelHeight(0)) {
      // GHOST VALUE IS AT OR UNDER THE LEVEL 0
      _bottom = -(_levelHeight(0) - ghostValue);
      _boxHeight = null;
    } else {
      // GHOST VALUE IS ABOVE THE LEVEL 0
      _bottom = 0;
      if (ghostValue < _lastLevelHeight) {
        // GHOST LEVEL IS AT OR UNDER THE LAST LEVEL
        // IF IT'S EXPANDABLE THIS WILL RUN
        _boxHeight = ghostValue;
      } else {
        // GHOST LEVEL IS ABOVE THE LAST LEVEL
        // IF IT'S NOT EXPANDABLE THIS WILL RUN
        _boxHeight = _lastLevelHeight;
        // INCREASE THE POSITION IF IT GOES ABOVE THE LAST LEVEL
        _startPosition = position + (_lastLevelHeight - _startValue!);
      }
    }
  }

  /// ASSERT THE GIVEN LEVEL IS VALID
  void _assertLevel(int level) {
    assert(
      (level <= levels.length && 0 <= level),
      "There is no level called Level $level.",
    );
  }

  // USE THIS INSTEAD OF _defaultHeight FOR READABILITY
  double _levelHeight(int level) {
    // ASSERT THE GIVEN LEVEL IS VALID
    _assertLevel(level);
    // FOR LEVEL 0, READS THE _defaultHeight VALUE INSTEAD OF THE LEVEL INSIDE THE LEVELS LIST
    // BECAUSE THE _defaultHeight PARAMETER WILL TAKE THE LEVEL'S HEIGHT WITH OTHER PARAMETERS INFLUENCE (LIKE allowToShrink)
    if (level == 0) return _defaultHeight!;
    return levels[level].height;
  }

  void _updateCurrentLevel() {
    // STARTS AS -1. BECAUSE THE FOR LOOP CANNOT CHECK WHAT LEVELS ARE LOWER THAN THE POSITIONs UNDER THE LEVEL 0
    // CAUSE THERE IS NO SUCH LEVEL EXISTS
    int newLevel = -1;
    // FIND THE LEVELS UNDER CURRENT SIZE
    for (int i = 0; i < levels.length; i++) {
      if (_value < _levelHeight(i)) break;
      newLevel = i;
    }
    // IF IT COMES FROM ANOTHER LEVEL ABOVE FOUND LEVEL
    // IT MUST BE STILL AT THE SAME LEVEL. BUT MAYBE IT'S TRYING TO MINIMIZE ITSELF
    if (_currentLevel > newLevel) {
      newLevel = newLevel + 1;
    }

    // DUE TO THE FIRST ASSIGNMENT WE NEED TO CHECK IF IT'S LOWER THAN 0 OR NOT
    _currentLevel = newLevel < 0 ? 0 : newLevel;
  }

  // FUNCTIONAL METHODS | END

  // GETTERS | START

  Curve get _animationCurve => widget.curve ?? Curves.ease;

  Duration get _animationDuraiton =>
      widget.animationDuration ?? const Duration(milliseconds: 320);

  double get _levelValue {
    if (_atUpperPart) {
      return _menuValue * _lastLevel;
    } else {
      return _menuValue;
    }
  }

  double get _menuValue {
    if (_raw == null) return 0;
    return (_raw! - _levelHeight(0)) /
        (_atUpperPart ? _upperPartHeight : _levelHeight(0));
  }

  double get _upperPartHeight => _lastLevelHeight - _levelHeight(0);

  /// IS THE MENU AT THE UPPER PART
  ///
  /// IT'S A NULL CHECK DO NOT USE IT LIKE IT'S A SIZE CHECK
  bool get _atUpperPart => _boxHeight != null;

  /// Visual size of the menu
  /// DO NOT USE IT INSIDE THE BUILD METHOD
  double get _value => _bottom + (_boxHeight ?? _levelHeight(0));

  /// IT'S LIKE _value BUT IT RETURNS IT NULLABLE
  ///
  /// IT'S CREATED TO USE THE GETTER INSIDE THE BUILD METHOD
  ///
  /// ONLY USE IT INSIDE THE BUILD METHOD
  double? get _raw {
    if (_defaultHeight == null) return null;
    return _bottom + (_boxHeight ?? _defaultHeight!);
  }

  /// Returns the current level's height
  double get _currentLevelHeight => _levelHeight(_currentLevel);

  double get _lastLevelHeight => _levelHeight(_lastLevel);

  /// LEVEL HEIGHT VALUE PASSED WITH THE LEVELS PARAMETER
  double? get _passedFirstLevelHeight {
    if (levels.isEmpty) return null;
    return levels.first.height;
  }

  bool get _canExpand => levels.length > 1;

  bool get _atMaxLevel => _currentLevel == _lastLevel;

  // NUMBER OF THE AVALIABLE LEVELS & LAST LEVEL NUMBER
  int get _lastLevel => (levels.length - 1) <= 0 ? 0 : (levels.length - 1);

  bool get _isUnderLevel => _value < _currentLevelHeight;

  // PARAMETER GETTERS
  bool get _minimizeBeforeFastDrag =>
      widget.blockMenuClosing ? true : widget.minimizeBeforeFastDrag;

  double get _fastDragVelocity => widget.fastDragVelocity ?? 1500;

  // STATUS CHECK GETTERS
  /// WILL THE MENU MINIMIZE ITSELF WHEN IT'S RELEASED
  bool get _willMinimize =>
      _levelHeight(_currentLevel) - _value >
      (widget.fixedMinimizeThreshold ??
          (_levelHeight(_currentLevel) - _levelHeight(_currentLevel - 1)) *
              (widget.minimizeThreshold ?? (1 / 3)));

  /// WILL THE MENU EXPAND ITSELF WHEN IT'S RELEASED
  bool get _willExpand =>
      _value - _levelHeight(_currentLevel) >
      (widget.fixedExpandThreshold ??
          (_levelHeight(_currentLevel + 1) - _levelHeight(_currentLevel)) *
              (widget.expandThreshold ?? (1 / 3)));

  /// WILL THE MENU CLOSE ITSELF WHEN IT'S RELEASED
  bool get _willClose => widget.fixedCloseThreshold == null
      ? (-_bottom / _levelHeight(0) > (widget.closeThreshold ?? (0.5)))
      : -_bottom > widget.fixedCloseThreshold!;

  /// IS THE MENU MOVING BY ITSELF
  bool get _isMoving =>
      _animationController.isAnimating ||
      _status == DraggableMenuStatus.closing;

  /// IS THE MENU STABLE (MEANS IS THE MENU AT ANY LEVEL)
  bool get _isStable => _currentLevelHeight == _value;

  /// IS THE MENU EXPANDED
  bool get _isExpanded {
    if (levels.length < 2) return false;
    return _value == _lastLevelHeight;
  }

  // UI GETTER
  Widget get _ui =>
      widget.customUi ??
      (widget.ui ?? _defaultUi).buildUi(
        context,
        widget.child,
        _status,
        _currentLevel,
        _menuValue,
        _raw,
        _levelValue,
        widget.animationDuration ?? const Duration(milliseconds: 320),
        widget.curve ?? Curves.ease,
      );

  // DEFINED MENU UI
  CustomDraggableMenu get _defaultUi => const ClassicDraggableMenu();

  // CONSTRAINS
  double get _minHeight =>
      widget.allowToShrink ? 0 : _passedFirstLevelHeight ?? 240;

  double get _maxHeight => _passedFirstLevelHeight ?? double.infinity;

  // GETTERS | END

  // CLASS FUNCTIONS SECTION | START

  @override
  void initState() {
    super.initState();
    _defaultHeightInit();
    _controllerInit();
    _levelsInit();
    _animationControllerInit();
    _tickerInit();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) => _onDragStart(details.globalPosition.dy),
      onVerticalDragUpdate: (details) =>
          _onDragUpdate(details.globalPosition.dy),
      onVerticalDragEnd: (details) => _onDragEnd(details),
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
            bottom: _bottom,
            child: ScrollableManagerScope(
              status: _status,
              canExpand: _canExpand,
              onDragStart: (globalPosition) => _onDragStart(globalPosition),
              onDragUpdate: (globalPosition) => _onDragUpdate(globalPosition),
              onDragEnd: (details) => _onDragEnd(details),
              child: UiFormatter(
                maxHeight: _boxHeight ?? _maxHeight,
                minHeight: _boxHeight ?? _minHeight,
                child: _ui,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // CLASS FUNCTIONS SECTION | END

  // MAIN MOVEMENT SECTION | START

  void _onDragStart(double globalPosition) {
    // STOP ANIMATIONS
    if (_animationController.isAnimating) _animationController.stop();

    // MOVMENT INIT
    _startPosition = globalPosition;
    _startValue = _value;
  }

  void _onDragUpdate(double globalPosition) {
    // ASSERT | START

    // ASSERT THE NEEDED VALUES
    assert(_startPosition != null);
    assert(_startValue != null);

    // ASSERT | END

    // LIVE MOVEMENT SECTION | START

    // CALCULATE THE DELTA FROM THE BEGINNING
    final double delta = _startPosition! - globalPosition;
    // GHOST VALUE
    final double ghostValue = _startValue! + delta;
    _convertGhost(ghostValue, globalPosition);

    // UPDATE THE CURRENT LEVEL AFTER SETTING THE POSITION
    _updateCurrentLevel();

    // LIVE MOVEMENT SECTION | END
  }

  void _onDragEnd(DragEndDetails details) {
    // IF IT CAN STABLE IT SELF BY DOING FAST DRAG DO NOT ANYTHING MORE
    if (_fastDrag(details)) return;

    // IF IT'S ALREADY STABLE DO NOT DO ANYTHING
    if (_isStable) return;

    // IT'S UNSTABLE. STABLEIZE IT.
    if (_bottom < 0) {
      // THE DOWN SIDE OF THE DRAGGABLE MENU
      if (_willClose) {
        _close();
      } else {
        _cancel();
      }
    } else {
      // THE UP SIDE OF THE DRAGGABLE MENU
      if (_isUnderLevel) {
        // THE DOWN SIDE OF THE CURRENT LEVEL
        if (_willMinimize) {
          _minimize();
        } else {
          _cancel();
        }
      } else {
        // THE UP SIDE OF THE CURRENT LEVEL
        if (!_atMaxLevel) {
          // THIS PART IS LOWER THAN THE MAX LEVEL
          if (_willExpand) {
            _expand();
          } else {
            _cancel();
          }
        } else {
          // THIS PART IS HIGHER THAN THE MAX LEVEL
          // KEEP THIS TO AVOID POSSIBLE BUGS
          _debug();
        }
      }
    }
  }

  // MAIN MOVEMENT SECTION | END

  // STATUS SECTION | START

  void _checkStatus() {
    // IF IT'S MOVING DO NOT CHANGE ITS STATUS WITH STATIC STATUS
    if (_isMoving) return;
    if (_isStable) {
      // STABLE
      if (_isExpanded) {
        _notifyStatusListener(DraggableMenuStatus.expanded);
      } else {
        _notifyStatusListener(DraggableMenuStatus.minimized);
      }
    } else {
      // UNSTABLE
      if (_bottom < 0) {
        // THE DOWN SIDE OF THE DRAGGABLE MENU
        if (_willClose) {
          _notifyStatusListener(DraggableMenuStatus.willClose);
        } else {
          _notifyStatusListener(DraggableMenuStatus.mayClose);
        }
      } else {
        // THE UP SIDE OF THE DRAGGABLE MENU
        if (_isUnderLevel) {
          // THE DOWN SIDE OF THE CURRENT LEVEL
          if (_willMinimize) {
            _notifyStatusListener(DraggableMenuStatus.willMinimize);
          } else {
            _notifyStatusListener(DraggableMenuStatus.mayMinimize);
          }
        } else {
          // THE UP SIDE OF THE CURRENT LEVEL
          if (!_atMaxLevel) {
            // THIS PART IS LOWER THAN THE MAX LEVEL
            if (_willExpand) {
              _notifyStatusListener(DraggableMenuStatus.willExpand);
            } else {
              _notifyStatusListener(DraggableMenuStatus.mayExpand);
            }
          } else {
            // THIS PART IS HIGHER THAN THE MAX LEVEL
            // KEEP THIS TO AVOID POSSIBLE BUGS
            _notifyStatusListener(DraggableMenuStatus.expanded);
          }
        }
      }
    }
  }

  /// NOTIFY THE STATUS LISTENERS
  void _notifyStatusListener(DraggableMenuStatus status) {
    // IF THE STATUS HASN'T CHANGED. DO NOT NOTIFY THE LISTENERS
    // ONLY NOTIFY THEM WHEN THE STATUS HAS CHANGED
    if (_status == status) return;

    // CHANGE THE STATUS
    _status = status;

    // NOTIFY THE LISTENERS AND PASS THE LEVEL THE STATUS FOR
    widget.addStatusListener?.call(status, _currentLevel);
  }

  // STATUS SECTION | END
}
