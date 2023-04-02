import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class ModernUi extends StatefulWidget {
  final Widget? child;
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final double? radius;
  final DraggableMenuStatus? status;
  final Duration? animationDuration;
  final Curve? curve;

  const ModernUi({
    super.key,
    this.child,
    this.barItem,
    this.accentColor,
    this.color,
    this.radius,
    this.status,
    this.animationDuration,
    this.curve,
  });

  @override
  State<ModernUi> createState() => _ModernUiState();
}

class _ModernUiState extends State<ModernUi> with TickerProviderStateMixin {
  double _padding = 16;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<double> _radiusAnimation;
  double? _radius;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 320),
    );

    listener() {
      setState(() {
        _padding = _animation.value;
      });
    }

    _animation = Tween<double>(begin: 16, end: 0).animate(
      _controller.drive(
        CurveTween(curve: widget.curve ?? Curves.ease),
      ),
    )..addListener(listener);

    radiusListener() {
      setState(() {
        _radius = _radiusAnimation.value;
      });
    }

    _radiusAnimation =
        Tween<double>(begin: widget.radius ?? 16, end: 0).animate(
      _controller.drive(
        CurveTween(curve: widget.curve ?? Curves.ease),
      ),
    )..addListener(radiusListener);
    super.initState();
  }

  @override
  void didUpdateWidget(ModernUi oldWidget) {
    if (oldWidget.status != widget.status) _notify(widget.status);
    super.didUpdateWidget(oldWidget);
  }

  _notify(DraggableMenuStatus? status) {
    if (status != null) {
      if (status == DraggableMenuStatus.mayExpand ||
          status == DraggableMenuStatus.expanding ||
          status == DraggableMenuStatus.expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.radius ?? 16),
            bottom: Radius.circular(_radius ?? widget.radius ?? 16)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color ?? DefaultColors.primaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child:
                    widget.barItem ?? DefaultBarItem(color: widget.accentColor),
              ),
              if (widget.child != null) Flexible(child: widget.child!),
            ],
          ),
        ),
      ),
    );
  }
}
