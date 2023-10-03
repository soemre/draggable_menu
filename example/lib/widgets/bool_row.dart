import 'package:example/config/color_palette.dart';
import 'package:flutter/widgets.dart';

import 'button.dart';

class BoolRow extends StatelessWidget {
  final void Function(bool result) onPressed;
  final String title;
  final bool active;

  const BoolRow({
    super.key,
    required this.onPressed,
    required this.title,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorPalette.title,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => onPressed(true),
                active: active,
                label: "True",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                onPressed: () => onPressed(false),
                active: !active,
                label: "False",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
