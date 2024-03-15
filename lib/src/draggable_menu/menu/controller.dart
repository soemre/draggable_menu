import 'package:flutter/material.dart';

class DraggableMenuController extends ChangeNotifier {
  late void Function(int level) animateTo;
  
  ///You can use `DraggableMenuController` to control the `DraggableMenu` widget.
  ///
  /// Provide the `DraggableMenuController` to the `controller` parameter of the `DraggableMenu`.
  ///
  /// ```dart
  /// DraggableMenu(
  ///   controller: _controller; // Provide the DraggableMenuController here
  ///   child: child,
  /// )
  /// ```
  ///
  /// And use one of the methods of the `DraggableMenuController` to control the `DraggableMenu` widget. For example:
  ///
  /// ```dart
  /// onTap: () => _controller.animateTo(1);
  /// ```
  ///
  /// ### Methods:
  /// - **animateTo()** - *Animates to given level.*
  DraggableMenuController();

  init(void Function(int level) animateTo) {
    this.animateTo = (level) => animateTo(level);
  }

  bool _isOpen = false;
  bool get isOpen => _isOpen;
  set isOpen(bool value) {
    _isOpen = value;
    notifyListeners();
  }
}
