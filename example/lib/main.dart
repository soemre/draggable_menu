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
  DraggableMenuUiType _type = DraggableMenuUiType.classic;
  bool _expand = false;
  bool _barrier = true;
  bool _enableExpandedScroll = false;
  bool _fastDrag = true;
  bool _minimizeBeforeFastDrag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draggable Menu Example"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _boolRow("Expand", _expand, (value) => _expand = value),
              const SizedBox(height: 8),
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
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _type = DraggableMenuUiType.classic;
                          }),
                          style: _type == DraggableMenuUiType.classic
                              ? const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                )
                              : null,
                          child: const Text("Classic"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _type = DraggableMenuUiType.modern;
                          }),
                          style: _type == DraggableMenuUiType.modern
                              ? const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                )
                              : null,
                          child: const Text("Modern"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _type = DraggableMenuUiType.softModern;
                          }),
                          style: _type == DraggableMenuUiType.softModern
                              ? const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                )
                              : null,
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
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomDraggableMenu(
                          uiType: _type,
                          expand: _expand,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
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
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomDraggableMenu(
                          uiType: _type,
                          expand: _expand,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                          child: ScrollableManager(
                            enableExpandedScroll: _enableExpandedScroll,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 50,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) => Material(
                                color: Colors.transparent,
                                child: ListTile(
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
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      onPressed: () => DraggableMenu.open(
                        context,
                        CustomDraggableMenu(
                          uiType: _type,
                          expand: _expand,
                          fastDrag: _fastDrag,
                          minimizeBeforeFastDrag: _minimizeBeforeFastDrag,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ColoredBox(
                                      color: Colors.red,
                                      child: ScrollableManager(
                                        enableExpandedScroll:
                                            _enableExpandedScroll,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 25,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) =>
                                              Material(
                                            color: Colors.transparent,
                                            child: ListTile(
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
                                  ),
                                  const SizedBox(width: 32),
                                  Flexible(
                                    child: ColoredBox(
                                      color: Colors.red,
                                      child: ScrollableManager(
                                        enableExpandedScroll:
                                            _enableExpandedScroll,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 25,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) =>
                                              Material(
                                            color: Colors.transparent,
                                            child: ListTile(
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
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.purple),
                      ),
                      onPressed: () => DraggableMenu.open(
                        context,
                        StatusDraggableMenu(
                          uiType: _type,
                          expand: _expand,
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
            color: Colors.red,
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
                    ? const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                      )
                    : null,
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
                    ? const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                      )
                    : null,
                child: const Text("False"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
