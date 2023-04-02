import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/menus/custom_draggable_menu.dart';
import 'package:example/menus/status_draggable_menu.dart';
import 'package:flutter/material.dart';

void main() {
  // Material Page and DraggableMenu.open() souldn't be in the same place
  runApp(const MaterialApp(home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  DraggableMenuUiType? _type;
  bool? _maximize;
  bool? _barrier;

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
              "Maximize:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _maximize = true,
                    child: const Text("True"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _maximize = false,
                    child: const Text("False"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Barrier:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 4),
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
            const SizedBox(height: 8),
            const Text(
              "UI Type:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _type = DraggableMenuUiType.classic,
                    child: const Text("Classic"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _type = DraggableMenuUiType.modern,
                    child: const Text("Modern"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                    maximize: _maximize,
                  ),
                  barrier: _barrier,
                ),
                child: const Text("Open The Menu"),
              ),
            ),
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
                    maximize: _maximize,
                    child: ListView.builder(
                      itemCount: 50,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) => Material(
                          color: Colors.transparent,
                          child: ListTile(
                              title: Text(
                            "Item ${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ))),
                    ),
                  ),
                  barrier: _barrier,
                ),
                child: const Text("Open The Menu with a Scrollable Inside"),
              ),
            ),
            const SizedBox(height: 8),
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
                    maximize: _maximize,
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
