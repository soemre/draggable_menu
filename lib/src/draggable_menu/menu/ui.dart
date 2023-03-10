import 'package:draggable_menu/src/default/colors.dart';
import 'package:flutter/material.dart';

class DraggableMenuUi extends StatelessWidget {
  final Widget? child;
  final Color? accentColor;
  final Color? color;
  final double? maxHeight;

  const DraggableMenuUi({super.key, this.child, this.accentColor, this.color, this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? DefaultColors.primaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? double.infinity,
              minHeight: 120,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: child,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 0,
          left: 0,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor ?? DefaultColors.primaryBackgroundAccent,
                borderRadius: const BorderRadius.all(
                  Radius.circular(36),
                ),
              ),
              child: const SizedBox(
                width: 64,
                height: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
