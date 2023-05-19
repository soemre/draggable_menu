import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class StatusDraggableMenu extends StatefulWidget {
  final bool expand;
  final bool enableExpandedScroll;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;
  final CustomDraggableMenu ui;

  const StatusDraggableMenu({
    super.key,
    required this.expand,
    required this.enableExpandedScroll,
    required this.fastDrag,
    required this.minimizeBeforeFastDrag,
    required this.ui,
  });

  @override
  State<StatusDraggableMenu> createState() => _StatusDraggableMenuState();
}

class _StatusDraggableMenuState extends State<StatusDraggableMenu> {
  Color _color = Colors.amber;
  String _text = "Minimized";
  double _value = 0;
  double? _raw;

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
        addStatusListener: (status) {
          setState(() {
            if (status == DraggableMenuStatus.canceling) {
              _color = Colors.blue;
              _text = "Canceling";
            }
            if (status == DraggableMenuStatus.closing) {
              _color = Colors.red;
              _text = "Closing";
            }
            if (status == DraggableMenuStatus.expanded) {
              _color = Colors.amber;
              _text = "Expanded";
            }
            if (status == DraggableMenuStatus.expanding) {
              _color = Colors.blue;
              _text = "Expanding";
            }
            if (status == DraggableMenuStatus.mayClose) {
              _color = Colors.green;
              _text = "May Close";
            }
            if (status == DraggableMenuStatus.willClose) {
              _color = Colors.purple;
              _text = "Will Close";
            }
            if (status == DraggableMenuStatus.willExpand) {
              _color = Colors.purple;
              _text = "Will Expand";
            }
            if (status == DraggableMenuStatus.willMinimize) {
              _color = Colors.purple;
              _text = "Will Minimize";
            }
            if (status == DraggableMenuStatus.mayExpand) {
              _color = Colors.green;
              _text = "May Expand";
            }
            if (status == DraggableMenuStatus.mayMinimize) {
              _color = Colors.green;
              _text = "May Minimize";
            }
            if (status == DraggableMenuStatus.minimized) {
              _color = Colors.amber;
              _text = "Minimized";
            }
            if (status == DraggableMenuStatus.minimizing) {
              _color = Colors.blue;
              _text = "Minimizing";
            }
          });
        },
        ui: widget.ui is ModernDraggableMenu
            ? ModernDraggableMenu(color: _color)
            : widget.ui is SoftModernDraggableMenu
                ? SoftModernDraggableMenu(color: _color)
                : ClassicDraggableMenu(color: _color),
        levels: [
          DraggableMenuLevel(height: MediaQuery.of(context).size.height * 0.50),
          DraggableMenuLevel(height: MediaQuery.of(context).size.height * 0.75),
          DraggableMenuLevel(height: MediaQuery.of(context).size.height * 1),
        ],
        maxHeight: MediaQuery.of(context).size.height * 0.25,
        minHeight: MediaQuery.of(context).size.height * 0.25,
        animationDuration: const Duration(seconds: 1),
        fastDrag: widget.fastDrag,
        minimizeBeforeFastDrag: widget.minimizeBeforeFastDrag,
        addValueListener: (value, raw) {
          setState(() {
            _value = value;
            _raw = raw;
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
                    _text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Menu Value: $_value\nRaw Value: $_raw\nUI Type: ${widget.ui is ModernDraggableMenu ? "Modern" : widget.ui is SoftModernDraggableMenu ? "Soft Modern" : "Classic"}\nExpand: ${widget.expand ? "True" : "False"}\nEnable Expanded Scroll: ${widget.enableExpandedScroll ? "True" : "False"}\nFast Drag: ${widget.fastDrag ? "True" : "False"}\nMinimize Before Fast Drag: ${widget.minimizeBeforeFastDrag ? "True" : "False"}",
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
