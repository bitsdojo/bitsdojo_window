# bitsdojo_window

A Flutter package that makes it easy to customize and work with your Flutter desktop app window. 

Watch the tutorial to get started: 

[![IMAGE ALT TEXT](http://img.youtube.com/vi/bee2AHQpGK4/0.jpg)](http://www.youtube.com/watch?v=bee2AHQpGK4 "Video Title")

<img src="https://github.com/bitsdojo/bitsdojo_window/blob/master/resources/screenshot.png">

**Features**:

    - Custom window frame - remove standard Windows titlebar and buttons
    - Hide window on startup
    - Show/hide window
    - Move window using Flutter widget
    - Minimize/Maximize/Restore/Close window
    - Set window size, minimum size and maximum size
    - Set window position
    - Set window alignment on screen (center/topLeft/topRight/bottomLeft/bottomRight)
    - Set window title


Currently working with Flutter desktop apps for **Windows**. macOS support is also planned in the future.

## Getting Started

Install the package using `pubspec.yaml`

Inside your application folder, go to `windows\runner\main.cpp` and add these two lines at the beginning of the file:

```
#include <bitsdojo_window/bitsdojo_window_plugin.h>
auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);
```

If you don't want to use a custom frame and prefer the standard Windows titlebar and buttons, you can remove the `BDW_CUSTOM_FRAME` flag from the code above.

If you don't want to hide the window on startup, you can remove the `BDW_HIDE_ON_STARTUP` flag from the code above.

Now go to `lib\main.dart` and add this code in the `main` function right after `runApp(MyApp());` :

```
void main() {
  runApp(MyApp());

  // Add this code below

  doWhenWindowReady(() {
    var initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
```
This will set an initial size and a minimum size for your application window, center it on the screen and show it on the screen.

You can find examples in the `example` folder.

Here is an example that displays this window:


```
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(MyApp());
  doWhenWindowReady(() {
    var win = appWindow;
    var initialSize = Size(600, 450);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

var borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: WindowBorder(
                color: borderColor,
                width: 1,
                child: Row(children: [LeftSide(), RightSide()]))));
  }
}

var sidebarColor = Color(0xFFF6A00C);

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: Container(
            color: sidebarColor,
            child: Column(
              children: [
                WindowTitleBarBox(child: MoveWindow()),
                Expanded(child: Container())
              ],
            )));
  }
}

var backgroundStartColor = Color(0xFFFFD500);
var backgroundEndColor = Color(0xFFF6A00C);

class RightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundStartColor, backgroundEndColor],
                  stops: [0.0, 1.0]),
            ),
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
            ])));
  }
}

var buttonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0xFFFFD500));

var closeButtonColors = WindowButtonColors(
    mouseOver: Colors.red[700],
    mouseDown: Colors.red[900],
    iconNormal: Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
```

TODO: More docs coming soon
