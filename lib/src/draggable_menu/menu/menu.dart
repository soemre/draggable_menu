import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/ui.dart';
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
    this.maximize,
    this.maximizedHeight,
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
  late final double? _maximizedHeight;
  late bool willMaximize;
  DraggableMenuStatus? _status;

  @override
  void initState() {
    super.initState();
    _maximizeInit();
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
        if (willMaximize) {
          if (_currentHeight != null) {
            if (_maximizedHeight! < _currentHeight!) {
              _currentHeight = _maximizedHeight;
              _currentHeightStart = _maximizedHeight;
              if (!_isMaximized) _isMaximized = true;
              _notifyStatusListener(DraggableMenuStatus.maximized);
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

  void _maximizeInit() {
    if (widget.maximize == true) {
      willMaximize = true;
      // willMaximize shouldn't be true if _maximizedHeight is null!
      if (widget.maximizedHeight != null) {
        if (widget.maxHeight != null) {
          if (widget.maximizedHeight! > widget.maxHeight!) {
            _maximizedHeight = widget.maximizedHeight!;
          } else {
            willMaximize = false;
          }
        } else {
          _maximizedHeight = widget.maximizedHeight!;
        }
      } else {
        if (widget.maxHeight != null) {
          _maximizedHeight = widget.maxHeight!;
        } else {
          willMaximize = false;
        }
      }
    } else {
      willMaximize = false;
    }
  }

  @override
  void didUpdateWidget(covariant DraggableMenu oldWidget) {
    if (oldWidget.maximize != widget.maximize) {
      _maximizeInit();
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
      onVerticalDragStart: (details) {
        if (_controller.isAnimating) _controller.stop();
        _yAxisStart = details.globalPosition.dy;
        _initHeight ??= _widgetKey.currentContext?.size?.height;
      },
      onVerticalDragUpdate: (details) {
        if (_yAxisStart == null) return;
        double valueChange = _yAxisStart! - details.globalPosition.dy;
        if (_value == 0 && valueChange > 0) {
          if (details.globalPosition.dy < _valueStart) return;
          if (willMaximize) {
            if (_maximizedHeight! > (_currentHeight ?? _initHeight!)) {
              _currentHeight =
                  (_currentHeightStart ?? _initHeight!) + valueChange;
              _notifyStatusListener(DraggableMenuStatus.mayMaximize);
            } else {
              // Opens the maximized feat
              if (!_isMaximized) {
                _currentHeight = _maximizedHeight;
                _currentHeightStart = _maximizedHeight;
                _isMaximized = true;
                _notifyStatusListener(DraggableMenuStatus.maximized);
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
              _notifyStatusListener(DraggableMenuStatus.mayMinimize);
            } else {
              _currentHeight = null;
              _currentHeightStart = null;
              _isMaximized = false;
              _yAxisStart = details.globalPosition.dy;
              _notifyStatusListener(DraggableMenuStatus.minimized);
            }
          } else {
            _value = _valueStart + valueChange;
            _notifyStatusListener(DraggableMenuStatus.mayClose);
          }
        }
      },
      onVerticalDragEnd: (details) {
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
          if (willMaximize) {
            if (_isMaximized == false) {
              if (_currentHeight! - _initHeight! >
                  (_maximizedHeight! - _initHeight!) / 3) {
                _openMaximized();
              } else {
                _closeMaximized();
              }
            } else {
              if (_maximizedHeight! - _currentHeight! >
                  (_maximizedHeight! - _initHeight!) / 3) {
                _closeMaximized();
              } else {
                _openMaximized();
              }
            }
          } else {
            _closeMaximized();
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
              minHeight: _currentHeight ?? widget.minHeight ?? 240,
              maxHeight: _currentHeight ?? widget.maxHeight ?? double.infinity,
              radius: widget.radius,
              barItem: widget.barItem,
              uiType: widget.uiType,
              customUi: widget.customUi,
              status: _status,
              curve: widget.curve,
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

  void _openMaximized() {
    _isMaximized = true;
    currentAnimation = 3;

    Animation<double> animation =
        Tween<double>(begin: _currentHeight, end: _maximizedHeight).animate(
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
        if (_currentHeight == _maximizedHeight) {
          _notifyStatusListener(DraggableMenuStatus.maximized);
        }
      }
    });
    _controller.reset();
    _notifyStatusListener(DraggableMenuStatus.maximizing);
    _controller.forward();
  }
}
