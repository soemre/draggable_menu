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
  DraggableMenuUiType? _type;
  bool? _expand;
  bool? _barrier;
  bool? _enableExpandedScroll;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draggable Menu Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expand:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _expand = true,
                    child: const Text("True"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _expand = false,
                    child: const Text("False"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "enableExpandedScroll:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _enableExpandedScroll = true,
                    child: const Text("True"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _enableExpandedScroll = false,
                    child: const Text("False"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Barrier:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _barrier = true,
                    child: const Text("True"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _barrier = false,
                    child: const Text("False"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "UI Type:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _type = DraggableMenuUiType.classic,
                    child: const Text("Classic"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _type = DraggableMenuUiType.modern,
                    child: const Text("Modern"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _type = DraggableMenuUiType.softModern,
                    child: const Text("Soft Modern"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Open:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                ),
                onPressed: () => DraggableMenu.open(
                  context,
                  CustomDraggableMenu(
                    uiType: _type,
                    expand: _expand,
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
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Row(
                          children: [
                            Flexible(
                              child: ColoredBox(
                                color: Colors.red,
                                child: ScrollableManager(
                                  enableExpandedScroll: _enableExpandedScroll,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: ScrollController(),
                                    itemCount: 25,
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) => Material(
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
                                  enableExpandedScroll: _enableExpandedScroll,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: ScrollController(),
                                    itemCount: 25,
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) => Material(
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
                  backgroundColor: MaterialStatePropertyAll(Colors.purple),
                ),
                onPressed: () => DraggableMenu.open(
                  context,
                  StatusDraggableMenu(
                    uiType: _type,
                    expand: _expand,
                    enableExpandedScroll: _enableExpandedScroll,
                  ),
                  barrier: _barrier,
                ),
                child: const Text("Status Menu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
