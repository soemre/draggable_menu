TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.


# Quick Start
To start as fast as you can, you just need to know how to create and how to open it.

## Create the Draggable Menu
Create a Draggable Menu with a child.

```dart
DraggableMenu(
  child: child, // Optional
)
```

## Open the Draggable Menu
Opent the menu by calling Draggable Menu's static "open" method.

```dart
DraggableMenu.open(
  context,
  DraggableMenu(
    child: child, // Optional
  ),
)
```

You can use the Draggable Menu inside of another widget and you can give it to open method. Like this:

```dart
DraggableMenu.open(
  context,
  MyCustomDraggableMenu(),
)
```

# Parameters of DraggableMenu

| Category | Parameters | Description |
|---|---|---|
| Constraints | double? minHeight | It specifies the min height of the Draggable Menu. If the child is bigger than this, it will take its child height insted. |
| Constraints | double? maxHeight | It specifies the max height of the Draggable Menu's minimized status (Not Expanded). If the menu is expandable, it takes its "maximizedHeight" parameter's value as fixed height. In order to use expandable draggable menu, the "maximizedHeight" parameter must be higher than "maxHeight" parameter. |
| Expandability | bool? maximize | It specifies whether the Draggable Menu will be expandable or not. The "maximizedHeight" parameter must be set to use expandable draggable menu. |
| Expandability | double? maximizedHeight | It specifies the height of the Draggable Menu when it's expanded. |
| UI | Widget? child | Adds an child inside the Draggable Menu's Default UI |
| UI | Color? color | Specifies the Background color of the Default UIs |
| UI | Color? accentColor | Specifies the Bar Item color of the Default UIs |
| UI | double? radius | Specifies the radius of the Default UIs. |
| UI | DraggableMenuUiType? uiType | Specifies the Default UI Type. |
| UI | Widget? barItem | Overrides the Default Bar Item of the Default UIs. |
| UI | Widget? customUi | Overrides the Default UIs. |
| Listener | Function(DraggableMenuStatus status)? addStatusListener | Adds a listener to listen its Status. |
| Animation | Duration? animationDuration | Specifies the duration of the Draggable Menu's animations. |
| Animaton | Curve? curve | Specifies the curve of the Draggable Menu's animations. |

# How To Use

## Create a Draggable Menu and Open it
You can create a Draggable Menu by just using:

```dart
DraggableMenu(
  child: child, // Optional
)
```

After that you will probably want to push the Draggable Menu to screen. To do that you can use "Navigator" or you can use the Draggable Menu's "open" or "openReplacement" methods. They are same with just a little one difference. The "openReplacement" method is replaceing the previous root (like "Navigator.pushReplacement").

```dart
DraggableMenu.open(
  context,
  DraggableMenu(
    child: child, // Optional
  ),
  barrier: barrier, // Optional. If it's true uses a root with barrier.
  barrierColor: barrierColor, // Optional. Changes the barrier's color.
  animationDuration: animationDuration, // Optional. Specifies its animation's duration.
  curve: animationDuration, // Optional. Specifies its animation's curve.
)
```

## Use the Expandable Draggable Menu
To do that, first, you should set the "maximize" parameter to true, and then set the value of the "maximizedHeight" parameter.

The "maximizedHeight" parameter mustn't be null or smaller than the childs height or the "maxHeight" or the "minHeight" parameters.

```dart
DraggableMenu(
  maximize: true,
  maximizedHeight: maximizedHeight,// Mustn't be null or smaller than its widget's height or the "maxHeight" or the "minHeight" parameters. 
  maxHeight: maxHeight, // Optional
  minHeight: minHeight, // Optional
  child: child, // Optional
)
```


## Use Different UIs
Use different UIs by setting the "uiType" parameter. The "uiType" parameter takes DraggableMenuUiType. And DraggableMenuUiType currently has these:
* Classic
* Modern

The "uiType" param is optional so if you don't use it, it's default value is "DraggableMenuUiType.classic".

```dart
DraggableMenu(
  uiType: DraggableMenuUiType.modern,
  child: child, // Optional
)
```


## Using Scrollables
While using scrollables with a Draggable Menu you don't need to do anything extra. You can just simply use it as its "child" parameter or you can use it inside of its "customUI" parameter.


## Using the Status Listener
Use the "addStatusListener" parameter to listen the Draggable Menu's status. 

### Dragable Menu's status are:
* Closing
* MayClose
* Canceling
* Minimized
* Minimizing
* May Maximize
* May Minimize
* Maximized
* Maximizing

You can point them out with DraggableMenuStatus like:
```dart
DraggableMenu(
  addStatusListener: (status) {
    if (status == DraggableMenuStatus.mayMaximize) {
      // Add something to do when its status is mayMaximize
    }
    // Add something to do when its status change
  }
  child: child, // Optional
)
```

Note: *You can find more examples in the Draggable Menu Example app.*