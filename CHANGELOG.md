# 1.0.0 Release

# What’s new

- Now the Draggable Menu is compatible with Dart 3

- Now you can create your own UIs more easily and better looking by making use of the `CustomDraggableMenu` class. For more info, take a look at the `Create your custom UI` section in the readme file.

- Using scrollables are now easier. *Check the `Using Scrollables` section under the `Breaking Changes` section if you are coming from an older version.*

# Breaking changes

## UI Type Update

- The way you choose one of the pre-build UIs changed. The `DraggableMenuUiType` enum and the `uiType` parameter of the `DraggableMenu` widget are removed. And now, if you want to change the UI, you should pass one of the Pre-build UI classes.

- `DraggableMenuUiType.classic` = `ClassicDraggableMenu`
`DraggableMenuUiType.modern` = `ModernDraggableMenu`
`DraggableMenuUiType.softModern` = `SoftModernDraggableMenu`

```dart
DraggableMenu(
  ui: SoftModernDraggableMenu();
  child: child,
)
```

- And the `barItem`, `radius`, `color` and `accentColor` parameters of the Default UI were removed as well. Now you can reach them inside of the Pre-Build UI classes' parameters.

```dart
DraggableMenu(
  ui: ClassicDraggableMenu(
    barItem: barItem,
    radius: radius,
    color: color,
  );
  child: child,
)
```

- If you just want to change the appearance of the `Draggable Menu` widget and don't want to make a huge change in its UI. Then, just pass the `ClassicDraggable` with the parameters you want it to be to the `ui` parameter of the `DraggableMenu` widget.

## Child Parameter of the `DraggableMenu` widget
- Now the `child` parameter is required for the `DraggableMenu` widget.

## Using Scrollables
- When using scrollables, don't give them a `scrollController` directly. If you want to use,  a `scrollController` to control the scrollable give it to the `ScrollManager` instead.