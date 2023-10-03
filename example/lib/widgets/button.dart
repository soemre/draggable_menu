import 'package:example/config/color_palette.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool active;
  final String label;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    this.onPressed,
    this.active = false,
    required this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: active
            ? style(ColorPalette.activeButton)
            : style(ColorPalette.passiveButton),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? ColorPalette.activeButtonTitle
                : ColorPalette.passiveButtonTitle,
          ),
        ),
      ),
    );
  }

  ButtonStyle style(Color color) => ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(12)),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      );
}
