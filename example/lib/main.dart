import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/menus/custom_draggable_menu.dart';
import 'package:example/menus/status_draggable_menu.dart';
import 'package:flutter/material.dart';

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
  final _controller = DraggableMenuController();
  CustomDraggableMenu _ui = const ClassicDraggableMenu();
  bool _barrier = true;
  bool _enableExpandedScroll = false;
  bool _fastDrag = true;
  bool _minimizeBeforeFastDrag = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 64),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Draggable Menu Example App",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "UI Type:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _ui = const ClassicDraggableMenu();
                          }),
                          style: _ui is ClassicDraggableMenu
                              ? style(Colors.deepOrange)
                              : style(Colors.indigoAccent),
                          child: const Text("Classic"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _ui = ModernDraggableMenu();
                          }),
                          style: _ui is ModernDraggableMenu
                              ? style(Colors.deepOrange)
                              : style(Colors.indigoAccent),
                          child: const Text("Modern"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _ui = const SoftModernDraggableMenu();
                          }),
                          style: _ui is SoftModernDraggableMenu
                              ? style(Colors.deepOrange)
                              : style(Colors.indigoAccent),
                          child: const Text("Soft Modern"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Open:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style(Colors.indigoAccent),
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
                      child: const Text("Open The Menu"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style(Colors.indigoAccent),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomMenu(
                          controller: _controller,
                          ui: _ui,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                          child: ScrollableManager(
                            enableExpandedScroll: _enableExpandedScroll,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: style(Colors.indigoAccent),
                                        onPressed: () =>
                                            _controller.animateTo(0),
                                        child: const Text("Animate To Level 0"),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: style(Colors.indigoAccent),
                                        onPressed: () =>
                                            _controller.animateTo(1),
                                        child: const Text("Animate To Level 1"),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: style(Colors.indigoAccent),
                                        onPressed: () =>
                                            _controller.animateTo(2),
                                        child: const Text("Animate To Level 2"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        barrier: _barrier,
                      ),
                      child: const Text("Test the Controller"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style(Colors.indigoAccent),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomMenu(
                          ui: _ui,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                          child: ScrollableManager(
                            enableExpandedScroll: _enableExpandedScroll,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 25,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {},
                                title: Text(
                                  "Item ${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        barrier: _barrier,
                      ),
                      child: const Text("Open The Menu with a Scrollable"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style(Colors.indigoAccent),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomMenu(
                          ui: _ui,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ColoredBox(
                                      color: Colors.indigoAccent,
                                      child: ScrollableManager(
                                        enableExpandedScroll:
                                            _enableExpandedScroll,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 25,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                              "Item ${index + 1}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Flexible(
                                    child: ColoredBox(
                                      color: Colors.indigoAccent,
                                      child: ScrollableManager(
                                        enableExpandedScroll:
                                            _enableExpandedScroll,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 25,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                              "Item ${index + 1}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        barrier: _barrier,
                      ),
                      child: const Text("Open the Menu with two Scrollable"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style(Colors.deepOrange),
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
                      child: const Text("Status Menu"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _boolRow(String title, bool button, Function(bool value) onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigoAccent,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() {
                  onPressed(true);
                }),
                style: button
                    ? style(Colors.deepOrange)
                    : style(Colors.indigoAccent),
                child: const Text("True"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() {
                  onPressed(false);
                }),
                style: !button
                    ? style(Colors.deepOrange)
                    : style(Colors.indigoAccent),
                child: const Text("False"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ButtonStyle style(Color color) {
    return ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(color),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(12)),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32),
          ),
        ),
      ),
    );
  }
}
