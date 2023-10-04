import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/menus/custom_draggable_menu.dart';
import 'package:example/menus/status_draggable_menu.dart';
import 'package:example/widgets/bar.dart';
import 'package:example/widgets/bool_row.dart';
import 'package:flutter/material.dart';

import 'config/color_palette.dart';
import 'menus/custom/scrollable.dart';
import 'menus/custom/test_controller.dart';
import 'menus/custom/two_scrollable.dart';
import 'widgets/button.dart';

void main() {
  // The DraggableMenu.open() shouldn't be in the same place as the MaterialApp widget.
  runApp(const MaterialApp(home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Type _ui = ClassicDraggableMenu;
  bool _barrier = true;
  bool _enableExpandedScroll = false;
  bool _fastDrag = true;
  bool _minimizeBeforeFastDrag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: const Bar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _boolRow(
                "Enable Expanded Scroll",
                _enableExpandedScroll,
                (value) => _enableExpandedScroll = value,
              ),
              const SizedBox(height: 8),
              _boolRow("Fast Drag", _fastDrag, (value) => _fastDrag = value),
              const SizedBox(height: 8),
              _boolRow(
                "Minimize Before Fast Drag",
                _minimizeBeforeFastDrag,
                (value) => _minimizeBeforeFastDrag = value,
              ),
              const SizedBox(height: 8),
              _boolRow("Barrier", _barrier, (value) => _barrier = value),
              const SizedBox(height: 8),
              const Text(
                "UI Type:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.title,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppButton(
                        padding: EdgeInsets.zero,
                        active: _ui == ClassicDraggableMenu,
                        onPressed: () => setState(() {
                          _ui = ClassicDraggableMenu;
                        }),
                        label: "Classic",
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        padding: EdgeInsets.zero,
                        active: _ui == ModernDraggableMenu,
                        onPressed: () => setState(() {
                          _ui = ModernDraggableMenu;
                        }),
                        label: "Modern",
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        padding: EdgeInsets.zero,
                        active: _ui == SoftModernDraggableMenu,
                        onPressed: () => setState(() {
                          _ui = SoftModernDraggableMenu;
                        }),
                        label: "Soft Modern",
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        padding: EdgeInsets.zero,
                        active: _ui == ModularDraggableMenu,
                        onPressed: () => setState(() {
                          _ui = ModularDraggableMenu;
                        }),
                        label: "Modular",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Open:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.title,
                ),
              ),
              AppButton(
                onPressed: () => DraggableMenu.open(
                  context,
                  CustomMenu(
                    ui: _ui,
                    fastDrag: _fastDrag,
                    minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                    child: const SizedBox(),
                  ),
                  barrier: _barrier,
                ),
                label: "Open The Menu",
              ),
              AppButton(
                onPressed: () => DraggableMenu.open(
                  context,
                  TestControllerMenu(
                    ui: _ui,
                    fastDrag: _fastDrag,
                    enableExpandedScroll: _enableExpandedScroll,
                    minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                  ),
                  barrier: _barrier,
                ),
                label: "Test the Controller",
              ),
              AppButton(
                onPressed: () => DraggableMenu.open(
                  context,
                  ScrollableMenu(
                    ui: _ui,
                    fastDrag: _fastDrag,
                    enableExpandedScroll: _enableExpandedScroll,
                    minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                  ),
                  barrier: _barrier,
                ),
                label: "Open The Menu with a Scrollable",
              ),
              AppButton(
                onPressed: () => DraggableMenu.open(
                  context,
                  TwoScrollableMenu(
                    ui: _ui,
                    fastDrag: _fastDrag,
                    enableExpandedScroll: _enableExpandedScroll,
                    minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                  ),
                  barrier: _barrier,
                ),
                label: "Open the Menu with two Scrollable",
              ),
              AppButton(
                active: true,
                onPressed: () => DraggableMenu.open(
                  context,
                  StatusDraggableMenu(
                    ui: _ui,
                    enableExpandedScroll: _enableExpandedScroll,
                    fastDrag: _fastDrag,
                    minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                  ),
                  barrier: _barrier,
                ),
                label: "Status Menu",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _boolRow(String title, bool active, Function(bool value) onPressed) {
    return BoolRow(
      title: title,
      active: active,
      onPressed: (result) => setState(() => onPressed(result)),
    );
  }
}
