import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/ui.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:draggable_menu/src/draggable_menu/utils/scrollable_manager/scrollable_manager_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableMenu extends StatefulWidget {
  final Widget? child;
  final Color? accentColor;
  final Color? color;
  final Duration? animationDuration;
  final double? maxHeight;
  final double? minHeight;
  final bool? expandable;
  final double? expandedHeight;
  final Widget? barItem;
  final double? radius;
  final Function(DraggableMenuStatus status)? addStatusListener;
  final DraggableMenuUiType? uiType;
  final Widget? customUi;
  final Curve? curve;

  const DraggableMenu({
    super.key,
    this.child,
    this.barItem,
    this.color,
    this.accentColor,
    this.minHeight,
    this.maxHeight,
    this.expandable,
    this.expandedHeight,
    this.animationDuration,
    this.radius,
    this.addStatusListener,
    this.customUi,
    this.uiType,
    this.curve,
  });

  static Future<T?>? open<T extends Object?>(
    BuildContext context,
    Widget draggableMenu, {
    Duration? animationDuration,
    Curve? curve,
    bool? barrier,
    Color? barrierColor,
  }) =>
      Navigator.maybeOf(context)?.push<T>(
        MenuRoute<T>(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
          barrier: barrier,
          barrierColor: barrierColor,
        ),
      );

  static Future? openReplacement(
    BuildContext context,
    Widget draggableMenu, {
    Duration? animationDuration,
    Curve? curve,
    bool? barrier,
    Color? barrierColor,
  }) =>
      Navigator.maybeOf(context)?.pushReplacement(
        MenuRoute(
          child: draggableMenu,
          duration: animationDuration,
          curve: curve,
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
      });
    });
    _ticker.start();
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
      onTapUp: (details) {
        final double? widgetHeight = _widgetKey.currentContext?.size?.height;
        if (widgetHeight == null) return;
        if (details.globalPosition.dy <
            MediaQuery.of(context).size.height - widgetHeight + _value) {
          _notifyStatusListener(DraggableMenuStatus.closing);
          Navigator.pop(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (details) => onDragStart(details.globalPosition.dy),
      onVerticalDragUpdate: (details) =>
          onDragUpdate(details.globalPosition.dy),
      onVerticalDragEnd: (details) => onDragEnd(),
      child: Stack(
        children: [
          Positioned(
            key: _widgetKey,
            bottom: _value,
            child: ScrollableManagerScope(
              onDragStart: (globalPosition) => onDragStart(globalPosition),
              onDragUpdate: (globalPosition) => onDragUpdate(globalPosition),
              onDragEnd: () => onDragEnd(),
              child: DraggableMenuUi(
                color: widget.color,
                accentColor: widget.accentColor,
                minHeight: _currentHeight ?? widget.minHeight ?? 240,
                maxHeight:
                    _currentHeight ?? widget.maxHeight ?? double.infinity,
                radius: widget.radius,
                barItem: widget.barItem,
                uiType: widget.uiType,
                customUi: widget.customUi,
                status: _status,
                curve: widget.curve,
                child: widget.child,
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
    _notifyStatusListener(DraggableMenuStatus.maximizing);
    _controller.forward();
  }

  onDragEnd() {
    final double? widgetHeight = _widgetKey.currentContext?.size?.height;
    if (widgetHeight == null) return;
    if (_currentHeight == null) {
      if (-_value / widgetHeight > 0.5) {
        _notifyStatusListener(DraggableMenuStatus.closing);
        Navigator.pop(context);
      } else {
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
      }
    } else {
      if (willExpand) {
        if (_isExpanded == false) {
          if (_currentHeight! - _initHeight! >
              (_expandedHeight! - _initHeight!) / 3) {
            _openExpanded();
          } else {
            _closeExpanded();
          }
        } else {
          if (_expandedHeight! - _currentHeight! >
              (_expandedHeight! - _initHeight!) / 3) {
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
}
