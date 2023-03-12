import 'package:draggable_menu/src/default/colors.dart';
import 'package:flutter/material.dart';

class DefaultBarItem extends StatelessWidget {
  const DefaultBarItem({
    super.key,
    required this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? DefaultColors.primaryBackgroundAccent,
          borderRadius: const BorderRadius.all(
            Radius.circular(36),
          ),
        ),
        child: const SizedBox(
          width: 40,
          height: 4,
        ),
      ),
    );
  }
}
