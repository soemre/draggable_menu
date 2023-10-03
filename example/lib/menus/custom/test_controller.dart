import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/widgets/button.dart';
import 'package:flutter/widgets.dart';

import '../custom_draggable_menu.dart';

class TestControllerMenu extends StatefulWidget {
  final CustomDraggableMenu ui;
  final bool enableExpandedScroll;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;

  const TestControllerMenu({
    super.key,
    required this.ui,
    required this.enableExpandedScroll,
    required this.fastDrag,
    required this.minimizeBeforeFastDrag,
  });

  @override
  State<TestControllerMenu> createState() => _TestControllerMenuState();
}

class _TestControllerMenuState extends State<TestControllerMenu> {
  final _controller = DraggableMenuController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMenu(
      controller: _controller,
      ui: widget.ui,
      fastDrag: widget.fastDrag,
      minimizeBeforeFastDrag: widget.minimizeBeforeFastDrag,
      child: ScrollableManager(
        enableExpandedScroll: widget.enableExpandedScroll,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () => _controller.animateTo(0),
                    label: "Animate To Level 0",
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () => _controller.animateTo(1),
                    label: "Animate To Level 1",
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () => _controller.animateTo(2),
                    label: "Animate To Level 2",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
