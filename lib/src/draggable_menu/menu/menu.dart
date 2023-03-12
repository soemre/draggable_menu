import 'package:draggable_menu/src/draggable_menu/menu/ui.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableMenu extends StatefulWidget {
  final Widget? child;
  final Color? accentColor;
  final Color? color;
  final Duration? animationDuration;
  final double? maxHeight;
  final double? minHeight;
  final bool? maximize;
  final double? maximizedHeight;

  const DraggableMenu({
    super.key,
    this.child,
    this.accentColor,
    this.color,
    this.animationDuration,
    this.maxHeight,
    this.minHeight,
    this.maximize,
    this.maximizedHeight,
  });

  static Future<T?>? open<T extends Object?>(
    BuildContext context,
    Widget draggableMenu, {
    Duration? animationDuration,
    bool? barrier,
    Color? barrierColor,
  }) =>
      Navigator.maybeOf(context)?.push<T>(
        MenuRoute<T>(
          child: draggableMenu,
          duration: animationDuration,
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
  bool _isMaximized = false;
  double? _currentHeightStart;
  int? currentAnimation;
  late final double _maximizedHeight;

  @override
  void initState() {
    super.initState();
    _maximizedHeight =
        widget.maximizedHeight ?? widget.maxHeight ?? double.infinity;
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
        if (_currentHeight != null) {
          if (_maximizedHeight < _currentHeight!) {
            _currentHeight = _maximizedHeight;
            _currentHeightStart = _maximizedHeight;
            if (!_isMaximized) _isMaximized = true;
          }
        }
      });
    });
    _ticker.start();
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
          Navigator.pop(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (details) {
        if (_controller.isAnimating) _controller.stop();
        _yAxisStart = details.globalPosition.dy;
        _initHeight ??= _widgetKey.currentContext?.size?.height;
      },
      onHorizontalDragUpdate: (details) {
        if (_yAxisStart == null) return;
        double valueChange = _yAxisStart! - details.globalPosition.dy;
        if (_value == 0 && valueChange > 0) {
          if (details.globalPosition.dy < _valueStart) return;
          if (widget.maximize == true) {
            // Will having the same height with init and max efect this?
            if (_maximizedHeight > (_currentHeight ?? _initHeight!)) {
              _currentHeight =
                  (_currentHeightStart ?? _initHeight!) + valueChange;
            } else {
              // Opened the maximized feat
              if (!_isMaximized) {
                _currentHeight = _maximizedHeight;
                _currentHeightStart = _maximizedHeight;
                _isMaximized = true;
              }
              _yAxisStart = details.globalPosition.dy - _valueStart;
            }
          } else {
            _yAxisStart = details.globalPosition.dy - _valueStart;
          }
        } else {
          if (_currentHeight != null) {
            if (_currentHeight! > _initHeight!) {
              _currentHeight =
                  (_currentHeightStart ?? _initHeight!) + valueChange;
            } else {
              _currentHeight = null;
              _currentHeightStart = null;
              _isMaximized = false;
              _yAxisStart = details.globalPosition.dy;
            }
          } else {
            _value = _valueStart + valueChange;
          }
        }
      },
      onHorizontalDragEnd: (details) {
        final double? widgetHeight = _widgetKey.currentContext?.size?.height;
        if (widgetHeight == null) return;
        if (_currentHeight == null) {
          if (-_value / widgetHeight > 0.5) {
            Navigator.pop(context);
          } else {
            currentAnimation = 1;
            Animation<double> animation =
                Tween<double>(begin: _value, end: 0).animate(
              _controller.drive(
                CurveTween(curve: Curves.ease),
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
              }
            });
            _controller.reset();
            _controller.forward();
          }
        } else {
          if (_isMaximized == false) {
            if (_currentHeight! - _initHeight! >
                (_maximizedHeight - _initHeight!) / 3) {
              _openMaximized();
            } else {
              _closeMaximized();
            }
          } else {
            if (_maximizedHeight - _currentHeight! >
                (_maximizedHeight - _initHeight!) / 3) {
              _closeMaximized();
            } else {
              _openMaximized();
            }
          }
        }
      },
      child: Stack(
        children: [
          Positioned(
            key: _widgetKey,
            bottom: _value,
            child: DraggableMenuUi(
              color: widget.color,
              accentColor: widget.accentColor,
              maxHeight: _currentHeight ?? widget.maxHeight ?? double.infinity,
              minHeight: _currentHeight ?? widget.minHeight ?? 240,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  void _closeMaximized() {
    _isMaximized = false;
    currentAnimation = 2;
    Animation<double> animation =
        Tween<double>(begin: _currentHeight, end: _initHeight).animate(
      _controller.drive(
        CurveTween(curve: Curves.ease),
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
      }
    });
    _controller.reset();
    _controller.forward();
  }

  void _openMaximized() {
    _isMaximized = true;
    currentAnimation = 3;

    Animation<double> animation =
        Tween<double>(begin: _currentHeight, end: _maximizedHeight).animate(
      _controller.drive(
        CurveTween(curve: Curves.ease),
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
      }
    });
    _controller.reset();
    _controller.forward();
  }
}
