import 'package:flutter/material.dart';

class UiFormatter extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final Widget child;

  const UiFormatter({
    super.key,
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: minHeight,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }
}
