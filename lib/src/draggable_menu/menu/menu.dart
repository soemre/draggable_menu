import 'package:draggable_menu/src/draggable_menu/menu/controller.dart';
import 'package:draggable_menu/src/draggable_menu/menu/custom_draggable_menu.dart';
import 'package:draggable_menu/src/draggable_menu/menu/draggable_menu_level.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui_formatter.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'ui/classic.dart';

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
  final CustomDraggableMenu ui;

  /// Adds a listener to listen to its Status.
  ///
  /// *To understand better the usage of the "Status Listeners",
  /// check out the [Draggable Menu Example](https://github.com/emresoysuren/draggable_menu/tree/main/example) app.*
  final void Function(DraggableMenuStatus status, int level)? addStatusListener;

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
  final void Function(double menuValue, double raw, double levelValue)?
      addValueListener;

  /// Specifies the duration of the Draggable Menu's animations.
  ///
  /// By default, it is `320ms`.
  final Duration animationDuration;

  /// Specifies the curve of the Draggable Menu's animations.
  ///
  /// By default, it is `Curves.ease`.
  final Curve curve;

  /// Specifies the Close Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `0.5`.
  final double closeThreshold;

  /// Specifies the Close Threshold of the Draggable Menu by giving it a fixed value.
  ///
  /// If it is not `null`, it will bypass both the default and the parameter percentage thresholds.
  final double? fixedCloseThreshold;

  /// Specifies the Expand Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `1/3`.
  final double expandThreshold;

  /// Specifies the Expand Threshold of the Draggable Menu by giving it a fixed value.
  ///
  /// If it is not `null`, it will bypass both the default and the parameter percentage thresholds.
  final double? fixedExpandThreshold;

  /// Specifies the Minimize Threshold of the Draggable Menu.
  ///
  /// Takes a value between `0` and `1`.
  ///
  /// By default, it is `1/3`.
  final double minimizeThreshold;

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
  final double fastDragVelocity;

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

  /// Defines the level at which the menu will start.
  ///
  /// Throws if the level doesn't exist.
  final int startLevel;
  
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
    this.ui = const ClassicDraggableMenu(),
    this.addStatusListener,
    this.addValueListener,
    this.animationDuration = const Duration(milliseconds: 320),
    this.curve = Curves.ease,
    this.closeThreshold = 0.5,
    this.expandThreshold = 1 / 3,
    this.minimizeThreshold = 1 / 3,
    this.fixedCloseThreshold,
    this.fixedExpandThreshold,
    this.fixedMinimizeThreshold,
    this.blockMenuClosing = false,
    this.fastDrag = true,
    this.fastDragVelocity = 1500,
    this.minimizeBeforeFastDrag = false,
    this.customUi,
    this.fastDragClose = true,
    this.fastDragMinimize = true,
    this.fastDragExpand = true,
    this.levels,
    this.allowToShrink = false,
    this.controller,
    required this.child,
    this.startLevel = 0,
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
    DraggableMenuController? controller,
  }) {
    controller?.isOpen = true;
    return Navigator.of(context).push<T>(
        MenuRoute<T>(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
          popCurve: popCurve,
          barrier: barrier,
          barrierColor: barrierColor,
        ),
      );
  }

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
    DraggableMenuController? controller,
  }) {
    controller?.isOpen = true;
     return Navigator.of(context).pushReplacement(
        MenuRoute(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
          popCurve: popCurve,
          barrier: barrier,
          barrierColor: barrierColor,
        ),
      );
  }

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu>
    with TickerProviderStateMixin {
  // Varibles | Start

  // For animation
  late final AnimationController _animationController;
  late Ticker _ticker;

  /// Removes the last animation when its called.
  ///
  /// It's called before running another animation.
  Function()? _removeLastAnimation;

  /// Size of the ui.
  double? _boxHeight;

  /// Bottom position of the ui.
  double _bottom = 0;

  /// Current level of the widget.
  int _currentLevel = 0;

  /// UI's normal size with its content
  /// before the `DraggableMenu` changes it.
  double? _defaultHeight;

  /// Stores the avaliable levels.
  List<DraggableMenuLevel> levels = [];

  /// Widget key is used to get the default
  /// height of the ui with it's content.
  final _widgetKey = GlobalKey();

  /// Start position of the drag event.
  double? _startPosition;

  /// Start size of the widget. (The current of the `_value` value is stored.)
  double? _startValue;

  // Status Values

  /// Stores the widget's current status.
  DraggableMenuStatus _status = DraggableMenuStatus.minimized;

  /// Stores the last value used to notify the value listeners.
  double? _valueLog;

  // Varibles | End

  // Functional Methods | Start

  // Init

  /// Initilizes the `_defaultHeight` value right after the build.
  void _defaultHeightInit() =>
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Set the current height as the default height before it changes
        _defaultHeight = _widgetKey.currentContext!.size!.height;
      });

  /// Initilizes the DraggableMenuController if it's passed.
  ///
  /// Listens the contoller and gives its `_animateTo` method.
  void _controllerInit() {
    // Initilizes the controller (Passes the _animeteTo method)
    widget.controller?.init((int level) => _animateTo(level));
    widget.controller?.isOpen = true;

    // Adds itself as listener to the controller
    widget.controller?.addListener(() {
    if (mounted) { // Check if the state is still mounted
      setState(() {});
    }
  });
  }

  /// Initilizes the `DraggableMenu` widget's levels.
  ///
  /// Only accepts valid levels.
  ///
  /// Valid Levels must have:
  /// - Different Heights
  ///
  /// If the widget ui's `expandable` parameter is set
  /// to `false`, it only uses the minimum height.
  void _levelsInit() {
    // Check if there is any level given to the levels parameter
    if (widget.levels?.isNotEmpty == true) {
      // Sorts the levels with their heights
      widget.levels!.sort((a, b) => a.height.compareTo(b.height));

      // If the menu is supposed to use only one fixed height,
      // just add the minimum height instead.
      if (widget.customUi == null && widget.ui.expandable == false) {
        levels.add(widget.levels![0]);
        return;
      }

      // DO NOT ADD THE LEVELS WITH SAME HEIGHT
      for (DraggableMenuLevel level in widget.levels!) {
        if (!levels.any((element) => element.height == level.height)) {
          levels.add(level);
        }
      }
    }
  }

  /// Initilizes the animation controller by
  /// assigning it to the `_animationController` variable.
  void _animationControllerInit() => _animationController =
      AnimationController(vsync: this, duration: widget.animationDuration);

  /// Initilizes the ticker.
  ///
  /// Only ticker calls the `setState` method.
  ///
  /// Ticker notifies the menu's listeners and debugs its sizes in every `setState` call.
  void _tickerInit() {
    // Create the ticker and assign it to the varible
    _ticker = createTicker((_) {
      setState(() {
        // Debug before display the new state
        _debug();

        // Notify the listeners before display the new state
        _notifyListeners();
      });
    });

    // Start the ticker
    _ticker.start();
  }

  /// Configures the Draggable Menu with the given configuration.
  ///
  /// Configures:
  /// - Start Height
  void _configurationInit() =>
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Initilize the start height
        _assertLevel(widget.startLevel);
        _currentLevel = widget.startLevel;
        _toHeight(_levelHeight(widget.startLevel));
        _notifyStatusListener(DraggableMenuStatus.minimized, true);
        _notifyValueListener();
      });

  // Debug

  /// Debug the possible overflowing bugs.
  ///
  /// Fixes the sizes higher than their constraints
  void _debug() {
    // Debug the _bottom value
    if (_bottom > 0) _bottom = 0;

    // Debug the _boxHeight value
    if (_boxHeight != null) {
      if (_lastLevelHeight < _boxHeight!) {
        // Cannot be heigher than the last level
        _boxHeight = _lastLevelHeight;
        _notifyStatusListener(DraggableMenuStatus.expanded);
      } else if (_boxHeight! <= _levelHeight(0)) {
        // Value cannot be equal or lower than the level 0
        _boxHeight = null;
      }
    }
  }

  // Listeners

  /// Notifies value and status listeners.
  ///
  /// The `_checkStatus` function is called to notify the status listeners.
  /// Therefore it will look up for the widget's current status.
  void _notifyListeners() {
    // Check the status and notify its listeners
    _checkStatus();

    // Notify the listeners with new values
    _notifyValueListener();
  }

  // Notify the value listeners
  _notifyValueListener() {
    if (_valueLog == _value) return;
    _valueLog = _value;
    return widget.addValueListener?.call(_menuValue, _value, _levelValue);
  }

  // Height Management

  /// Sets widget's height to given height.
  ///
  /// Converts height to `_bottom` and `_boxHeight` values.
  void _toHeight(double height) {
    if (height <= _levelHeight(0)) {
      _bottom = height - _levelHeight(0);
      _boxHeight = null;
    } else {
      _bottom = 0;
      _boxHeight = height;
    }
  }

  // _animateTo Method

  /// Animates to the given level.
  ///
  /// If the given level doesn't exist, it will throw.
  ///
  /// Notifies the status listener with one of these:
  /// - `DraggableMenuStatus.minimizing`
  /// - `DraggableMenuStatus.canceling`
  /// - `DraggableMenuStatus.expanding`
  void _animateTo(int level) {
    // Assert if the given level is valid
    _assertLevel(level);

    // Notify the status listener with one of the animating status.
    if (level < _currentLevel) {
      _notifyStatusListener(DraggableMenuStatus.minimizing);
    } else if (level == _currentLevel) {
      _notifyStatusListener(DraggableMenuStatus.canceling);
    } else {
      _notifyStatusListener(DraggableMenuStatus.expanding);
    }

    // Set the given level as the current level
    _currentLevel = level;

    // Remove the last animations listener if it's still listening
    _removeLastAnimation?.call();

    // Assign the animation and callback values

    final Animation<double> animation =
        Tween<double>(begin: _value, end: _levelHeight(level)).animate(
      _animationController.drive(CurveTween(curve: widget.curve)),
    );

    // Reflect to the value changes
    void callback() => _toHeight(animation.value);

    // Store the remove listener callback
    _removeLastAnimation = () => animation.removeListener(callback);

    // Add callback as the listener
    animation.addListener(callback);

    // Run the animation
    _animationController.reset();
    _animationController.forward();
  }

  // Default animate methods

  /// Minimizes to current level.
  ///
  /// If the current level isn't higher than 0, does nothing.
  void _minimize() {
    // If current height is lower than or equal to the level 0' height, it's not higher than the level 0.
    // So do nothing.
    if (!_atUpperPart) return;

    // Minimize
    _animateTo(_currentLevel - 1);
  }

  /// Expands the current level.
  ///
  /// If it is at the highest level, does nothing.
  void _expand() {
    // If it is already expanded, do nothing.
    if (_isExpanded) return;

    // Expand
    _animateTo(_currentLevel + 1);
  }

  /// Cancels the current drag movement and stabilizes to the previous level.
  ///
  /// If it is already at the stable height, does nothing.
  void _cancel() {
    // If it is already stable. Don't try to stabilize it
    if (_isStable) return;

    // Cancel (Stabilize)
    _animateTo(_currentLevel);
  }

  /// Close pops the draggable menu.
  ///
  /// If the `blockMenuClosing` is set to `true`, it won't pop beacuse it calles maybePop.
  /// And due to that pop should called programaticlly.
  void _close() {
    // The blockMenuClosing parameter can cancel the operation
    if (widget.blockMenuClosing) return _cancel();

    // Close
    _notifyStatusListener(DraggableMenuStatus.closing);
    Navigator.maybePop(context);
  }

  // Fast Drag

  /// Checks the drag movment when it ends.
  /// If the drag velocity is faster than widget's velocity thresold,
  /// animates to the corresponding level with the corresponding animation
  /// and returns `true`. If it won't do anything, it returns false.
  bool _fastDrag(DragEndDetails details) {
    // Check the widget parameters
    if (!widget.fastDrag) return false;
    assert(
      !widget.fastDragVelocity.isNegative,
      "The `fastDragVelocity` parameter can't be negative.",
    );

    // Operation
    final double velocity = details.velocity.pixelsPerSecond.dy;
    if (velocity > widget.fastDragVelocity) {
      // Fast dragging to down
      if ((_minimizeBeforeFastDrag && _boxHeight == null) ||
          !_minimizeBeforeFastDrag) {
        // Under the level 0 or will close when drag fast
        if (widget.fastDragClose) {
          _close();
          return true;
        }
      } else if (_minimizeBeforeFastDrag && _boxHeight != null) {
        // Above the level 0
        if (widget.fastDragMinimize) {
          _minimize();
          return true;
        }
      }
    } else if (velocity < -widget.fastDragVelocity) {
      // Fast dragging to up
      // Cannot be at the last level
      if (!_atMaxLevel && widget.fastDragExpand) {
        _expand();
        return true;
      }
    }
    return false;
  }

  /// Converts ghost value to actual widget size.
  ///
  /// Instead of returning it, implements it to the widget.
  void _convertGhost(double ghostValue, double position) {
    assert(_startValue != null);

    if (ghostValue <= _levelHeight(0)) {
      // Ghost value is at or under the level 0
      _bottom = -(_levelHeight(0) - ghostValue);
      _boxHeight = null;
    } else {
      // Ghost value is above the level 0
      _bottom = 0;
      if (ghostValue < _lastLevelHeight) {
        // Ghost level is at or under the last level
        // If it's expandable, run this.
        _boxHeight = ghostValue;
      } else {
        // Ghost level is above the last level
        // If it's not expandable, run this.
        _boxHeight = _lastLevelHeight;
        // Increase the position if it goes above the last level
        _startPosition = position + (_lastLevelHeight - _startValue!);
      }
    }
  }

  /// Checks if the given level exists. If it's not it throws.
  void _assertLevel(int level) {
    assert(
      (level <= levels.length && 0 <= level),
      "There is no level called Level $level.",
    );
  }

  /// Returns the given level's height.
  ///
  /// Use this instead of _defaultHeight when you want to get the level 0 for readability.
  double _levelHeight(int level) {
    // Assert the given level is valid
    _assertLevel(level);
    // For level 0, reads the _defaultHeight value instead of the level inside the levels list
    // Because the _defaultHeight parameter will take the level's height with other parameters influence (eg. allowToShrink)
    if (level == 0) return _defaultHeight!;
    return levels[level].height;
  }

  /// Updates the widget's current level value with the corresponding new level.
  void _updateCurrentLevel() {
    // Starts as -1. Because if the level's height is under the level 0, it still has to be level 0.
    int newLevel = -1;

    // Find the levels under current size
    for (int i = 0; i < levels.length; i++) {
      if (_value < _levelHeight(i)) break;
      newLevel = i;
    }

    // If is comes from another level above, it must still be at the same level.
    // But then the for loop miscalculated its level so we need to add 1 to the current level.
    // Because even if it's under the level, it's coming from one level above.
    if (_currentLevel > newLevel) {
      newLevel = newLevel + 1;
    }

    // Due to the first assignment (assigning -1), we need to check if it's lower than 0.
    // It won't be because we are checking if it comes from upper level.
    _currentLevel = newLevel < 0 ? 0 : newLevel;
  }

  // Functional Methods | End

  // Getters | Start

  /// **Values:**
  /// - +n : At the level n.
  /// -  0 : At the level 0.
  /// - -1 : At the bottom of the app. (Not visible)
  double get _levelValue {
    if (_atUpperPart) {
      return _menuValue * _lastLevel;
    } else {
      return _menuValue;
    }
  }

  /// **Values:**
  /// - +1 : At the highest level.
  /// -  0 : At the level 0.
  /// - -1 : At the bottom of the app. (Not visible)
  double get _menuValue {
    if (_raw == null) return 0;
    return (_raw! - _levelHeight(0)) /
        (_atUpperPart ? _upperPartHeight : _levelHeight(0));
  }

  double get _upperPartHeight => _lastLevelHeight - _levelHeight(0);

  /// Is the menu at the upper part
  ///
  /// It's just a null check, do not use it like it's a size check
  bool get _atUpperPart => _boxHeight != null;

  /// Visual size of the menu
  /// Don't use it inside the build method
  double get _value => _bottom + (_boxHeight ?? _levelHeight(0));

  /// It's like _value but it returns it nullable
  ///
  /// It's created to use the getter inside the build method
  ///
  /// Only use it inside the build method
  double? get _raw {
    if (_defaultHeight == null) return null;
    return _bottom + (_boxHeight ?? _defaultHeight!);
  }

  /// Returns the current level's height
  double get _currentLevelHeight => _levelHeight(_currentLevel);

  /// Returns the last level's height
  double get _lastLevelHeight => _levelHeight(_lastLevel);

  /// Level height value passed with the levels parameter
  double? get _passedFirstLevelHeight {
    if (levels.isEmpty) return null;
    return levels.first.height;
  }

  /// Does the widget have enough levels to expand
  bool get _canExpand => levels.length > 1;

  /// Is the menu at the max level or not
  bool get _atMaxLevel => _currentLevel == _lastLevel;

  /// Number of the avaliable level (Last level number) (*Not as lenght*)
  int get _lastLevel => (levels.length - 1) <= 0 ? 0 : (levels.length - 1);

  /// Is the level's position under the its current level height
  bool get _isUnderLevel => _value < _currentLevelHeight;

  // Parameter Getters

  /// Should the widget minimize itself when fast dragging or not.
  ///
  /// By default, if the `widget.blockMenuClosing` parameter is `true` it's `true` as well.
  bool get _minimizeBeforeFastDrag =>
      widget.blockMenuClosing || widget.minimizeBeforeFastDrag;

  // Status Check Getters
  /// Will the menu minimize itself when it's released
  bool get _willMinimize =>
      _levelHeight(_currentLevel) - _value >
      (widget.fixedMinimizeThreshold ??
          (_levelHeight(_currentLevel) - _levelHeight(_currentLevel - 1)) *
              widget.minimizeThreshold);

  /// Will the menu expand itself when it's released
  bool get _willExpand =>
      _value - _levelHeight(_currentLevel) >
      (widget.fixedExpandThreshold ??
          (_levelHeight(_currentLevel + 1) - _levelHeight(_currentLevel)) *
              widget.expandThreshold);

  /// Will the menu close itself when it's released
  bool get _willClose => widget.fixedCloseThreshold == null
      ? (-_bottom / _levelHeight(0) > widget.closeThreshold)
      : -_bottom > widget.fixedCloseThreshold!;

  /// Is the menu moving by itself (Like animating or pop)
  bool get _isMoving =>
      _animationController.isAnimating ||
      _status == DraggableMenuStatus.closing;

  /// Is the menu stable (It means "Is the menu at any level?")
  bool get _isStable => _currentLevelHeight == _value;

  /// Is the menu expanded
  bool get _isExpanded {
    if (levels.length < 2) return false;
    return _value == _lastLevelHeight;
  }

  /// Returns the right UI with passing it parameters.
  Widget get _ui =>
      widget.customUi ??
      widget.ui.buildUi(
        context,
        widget.child,
        _status,
        _currentLevel,
        _menuValue,
        _raw,
        _levelValue,
        widget.animationDuration,
        widget.curve,
      );

  // Constrains
  double get _minHeight =>
      widget.allowToShrink ? 0 : _passedFirstLevelHeight ?? 240;

  double get _maxHeight => _passedFirstLevelHeight ?? double.infinity;

  // Getters | End

  // Class Functions Section | Start

  @override
  void initState() {
    // Always seperate the initialization to different funcitons.
    super.initState();
    _defaultHeightInit();
    _controllerInit();
    _levelsInit();
    _animationControllerInit();
    _tickerInit();
    _configurationInit();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.blockMenuClosing,
      onPopInvoked: (bool isPoping) {
        if (isPoping) _notifyStatusListener(DraggableMenuStatus.closing);
      },
      child: GestureDetector(
        onVerticalDragStart: (details) =>
            _onDragStart(details.globalPosition.dy),
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
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.isOpen = false;
    _ticker.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Class Functions Section | End

  // Main Movement Section | Start

  /// Handels the drag start event.
  ///
  /// Stops the current animations and assigns
  /// the new start references to the variables.
  void _onDragStart(double globalPosition) {
    // Stop animations
    if (_animationController.isAnimating) _animationController.stop();

    // Movement init
    _startPosition = globalPosition;
    _startValue = _value;
  }

  /// Handels the drag update event.
  ///
  /// Calculates movement delta with `_startPosition` and ghosValue.
  ///
  /// **Ghost Value** = (Menu's drag start event size reference) + (Size Change Delta)
  /// Why do we call it ghost? Because it's not the actual size menu will be.
  /// It just stores what users input trying to make the menu's size.
  /// The actual size will be converted from the ghost value.
  /// Because if we don't track all the movment,we might lose user's position.
  ///
  /// And lastly, it updates the widgets level with the corresponding level to its height.
  void _onDragUpdate(double globalPosition) {
    // Assert the reference values
    assert(_startPosition != null);
    assert(_startValue != null);

    // Calculate the delta from the beginning
    final double delta = _startPosition! - globalPosition;

    // Ghost value
    final double ghostValue = _startValue! + delta;
    _convertGhost(ghostValue, globalPosition);

    // Update the current level after setting the position
    _updateCurrentLevel();
  }

  /// Handels the drag end event.
  ///
  /// If the movement allows to do a fastdrag event, it does the fastdrag event and returns.
  ///
  /// It does corresponding events depending on the widget's size.
  /// For example doing nothing if it is stable, or expanding etc.
  void _onDragEnd(DragEndDetails details) {
    // If it can stable itself by doing fast drag don't do anyting
    if (_fastDrag(details)) return;

    // If it's already stable don't do anything
    if (_isStable) return;

    // It's unstable. Stabilize it.
    if (_bottom < 0) {
      // The down side of the draggable menu
      if (_willClose) {
        _close();
      } else {
        _cancel();
      }
    } else {
      // The up side of the draggable menu
      if (_isUnderLevel) {
        // The down side of the current level
        if (_willMinimize) {
          _minimize();
        } else {
          _cancel();
        }
      } else {
        // The up side of the current level
        if (!_atMaxLevel) {
          // This part is lower than the max level
          if (_willExpand) {
            _expand();
          } else {
            _cancel();
          }
        } else {
          // This part is higher than the max level
          // Keep this to avoid possible bugs
          _debug();
        }
      }
    }
  }

  // Main Movement Section | End

  // Status Section | Start

  /// Notifies the status listeners with checking the widget's current status.
  ///
  /// If it's moving (means the menu animating itself), it does nothing and returns.
  /// Because the listeners should be notified by the dynamic status types while animating.
  void _checkStatus() {
    // If it's moving don't change its status with static status
    if (_isMoving) return;
    if (_isStable) {
      // The Menu is stable
      if (_isExpanded) {
        _notifyStatusListener(DraggableMenuStatus.expanded);
      } else {
        _notifyStatusListener(DraggableMenuStatus.minimized);
      }
    } else {
      // The menu is unstable
      if (_bottom < 0) {
        // The down side of the menu
        if (_willClose) {
          _notifyStatusListener(DraggableMenuStatus.willClose);
        } else {
          _notifyStatusListener(DraggableMenuStatus.mayClose);
        }
      } else {
        // The up side of the menu
        if (_isUnderLevel) {
          // The down side of the current level
          if (_willMinimize) {
            _notifyStatusListener(DraggableMenuStatus.willMinimize);
          } else {
            _notifyStatusListener(DraggableMenuStatus.mayMinimize);
          }
        } else {
          // The up side of the current level
          if (!_atMaxLevel) {
            // This part is lower than the max level
            if (_willExpand) {
              _notifyStatusListener(DraggableMenuStatus.willExpand);
            } else {
              _notifyStatusListener(DraggableMenuStatus.mayExpand);
            }
          } else {
            // This part is higher than the max level
            // Keep this to avoid possible bugs
            _notifyStatusListener(DraggableMenuStatus.expanded);
          }
        }
      }
    }
  }

  /// Notifies the status listener with the given status
  /// and assigns the new status to the `_status` variable as well.
  ///
  /// If the `bypass` parameter set to `true`, it doesn't check if the
  /// same status is being assigned or not.
  void _notifyStatusListener(DraggableMenuStatus status,
      [bool bypass = false]) {
    // If the status hasn't changed. Don't notify the listeners
    // Only notify them when the status has changed
    if (!bypass && _status == status) return;

    // Change the status
    _status = status;

    // Notify the listeners and pass the level the status related to
    widget.addStatusListener?.call(status, _currentLevel);
  }

  // Status Section | End
}
