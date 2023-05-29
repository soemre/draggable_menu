import 'package:flutter/material.dart';

class DraggableMenuController extends ChangeNotifier {
  late void Function(int level) animateTo;

  DraggableMenuController();

  init(void Function(int level) animateTo) {
    this.animateTo = (level) => animateTo(level);
  }
}
