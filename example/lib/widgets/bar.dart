import 'package:flutter/widgets.dart';

import '../config/color_palette.dart';

class Bar extends StatelessWidget implements PreferredSizeWidget {
  const Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorPalette.appBarBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Draggable Menu Example App",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorPalette.appBarTitle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 80);
}
