import 'package:flutter/material.dart';

class MenuRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  MenuRoute(
      {Duration? duration,
      required this.child,
      bool? barrier,
      Color? barrierColor})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration ?? const Duration(milliseconds: 320),
          reverseTransitionDuration:
              duration ?? const Duration(milliseconds: 320),
          opaque: false,
          barrierColor:
              barrier == true ? barrierColor ?? const Color(0x80000000) : null,
          barrierDismissible: true,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(
        animation.drive(
          CurveTween(curve: Curves.ease),
        ),
      ),
      child: child,
    );
  }
}
