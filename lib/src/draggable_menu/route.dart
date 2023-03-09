import 'package:flutter/material.dart';

class MenuRoute extends PageRouteBuilder {
  final Widget child;

  MenuRoute({Duration? duration, required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration ?? const Duration(milliseconds: 320),
          reverseTransitionDuration:
              duration ?? const Duration(milliseconds: 320),
          opaque: false,
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
