import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class StatusDraggableMenu extends StatefulWidget {
  final DraggableMenuUiType? uiType;
  final bool? expand;
  final bool? enableExpandedScroll;

  const StatusDraggableMenu({
    super.key,
    this.uiType,
    this.expand,
    this.enableExpandedScroll,
  });

  @override
  State<StatusDraggableMenu> createState() => _StatusDraggableMenuState();
}

class _StatusDraggableMenuState extends State<StatusDraggableMenu> {
  Color? _color;
  String? _text;
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
        addStatusListener: (status) {
          if (status == DraggableMenuStatus.canceling) {
            setState(() {
              _color = Colors.blue;
              _text = "Canceling";
            });
          }
          if (status == DraggableMenuStatus.closing) {
            setState(() {
              _color = Colors.red;
              _text = "Closing";
            });
          }
          if (status == DraggableMenuStatus.expanded) {
            setState(() {
              _color = Colors.amber;
              _text = "Expanded";
            });
          }
          if (status == DraggableMenuStatus.expanding) {
            setState(() {
              _color = Colors.blue;
              _text = "Expanding";
            });
          }
          if (status == DraggableMenuStatus.mayClose) {
            setState(() {
              _color = Colors.green;
              _text = "May Close";
            });
          }
          if (status == DraggableMenuStatus.mayExpand) {
            setState(() {
              _color = Colors.green;
              _text = "May Expand";
            });
          }
          if (status == DraggableMenuStatus.mayMinimize) {
            setState(() {
              _color = Colors.green;
              _text = "May Minimize";
            });
          }
          if (status == DraggableMenuStatus.minimized) {
            setState(() {
              _color = Colors.amber;
              _text = "Minimized";
            });
          }
          if (status == DraggableMenuStatus.minimizing) {
            setState(() {
              _color = Colors.blue;
              _text = "Minimizing";
            });
          }
        },
        uiType: widget.uiType,
        expandable: widget.expand,
        color: _color,
        expandedHeight: MediaQuery.of(context).size.height * 0.72,
        animationDuration: const Duration(seconds: 1),
        addValueListener: (value) {
          setState(() {
            _value = value;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    _text ?? "When you move the menu it will show its status.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Menu Value: $_value\nUI Type: ${widget.uiType == DraggableMenuUiType.modern ? "Modern" : "Classic"}\nExpand: ${widget.expand == true ? "True" : "False"}\nenableExpandedScroll: ${widget.enableExpandedScroll == true ? "True" : "False"}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
