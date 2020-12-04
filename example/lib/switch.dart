/*
Don't forget to add these 2 lines at the beggining of windows\runner\main.cpp

#include <bitsdojo_window/bitsdojo_window_plugin.h>
auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);

*/

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class AppSkin {
  Color sidebar;
  Color backgroundStart;
  Color backgroundEnd;
  Color border;
  Color buttonMouseOver;
  Color buttonMouseDown;
  Color icon;
  Color iconMouseOver;
  Color iconMouseDown;

  AppSkin(
      {@required this.sidebar,
      @required this.backgroundStart,
      @required this.backgroundEnd,
      @required this.border,
      @required this.buttonMouseOver,
      @required this.buttonMouseDown,
      @required this.icon,
      @required this.iconMouseOver,
      @required this.iconMouseDown});
}

AppSkin yellowSkin = AppSkin(
  sidebar: Color(0xFFF6A00C),
  backgroundStart: Color(0xFFFFD500),
  backgroundEnd: Color(0xFFF6A00C),
  border: Color(0xFF805306),
  buttonMouseOver: Color(0xFFF6A00C),
  buttonMouseDown: Color(0xFF805306),
  icon: Color(0xFF805306),
  iconMouseOver: Color(0xFF805306),
  iconMouseDown: Color(0xFFFFD500),
);

AppSkin greenSkin = AppSkin(
    sidebar: Color(0xFF198A00),
    backgroundStart: Color(0xFF25C901),
    backgroundEnd: Color(0xFF198A00),
    border: Color(0xFF0C4500),
    buttonMouseOver: Color(0xFF198A00),
    buttonMouseDown: Color(0xFF0C4500),
    icon: Color(0xFF0C4500),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin blueSkin = AppSkin(
    sidebar: Color(0xFF125CDB),
    backgroundStart: Color(0xFF079BF2),
    backgroundEnd: Color(0xFF125CDB),
    border: Color(0xFF092E6E),
    buttonMouseOver: Color(0xFF125CDB),
    buttonMouseDown: Color(0xFF092E6E),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin purpleSkin = AppSkin(
    sidebar: Color(0xFF8700B2),
    backgroundStart: Color(0xFFCC00C5),
    backgroundEnd: Color(0xFF9A00CC),
    border: Color(0xFF730099),
    buttonMouseOver: Color(0xFF9A00CC),
    buttonMouseDown: Color(0xFF730099),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

AppSkin cherrySkin = AppSkin(
    sidebar: Color(0xFF850250),
    backgroundStart: Color(0xFFC90078),
    backgroundEnd: Color(0xFF850250),
    border: Color(0xFF700043),
    buttonMouseOver: Color(0xFF850250),
    buttonMouseDown: Color(0xFF700043),
    icon: Color(0xFFFFFFFF),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFFFFFFF));

var skins = [yellowSkin, greenSkin, blueSkin, purpleSkin, cherrySkin];

class AppColors extends InheritedWidget {
  final AppSkin colors;
  final Widget child;
  const AppColors({
    Key key,
    @required this.colors,
    @required this.child,
  }) : super(key: key, child: child);

  static AppColors of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppColors>();
  }

  @override
  bool updateShouldNotify(AppColors old) => colors != old.colors;
}

void main() {
  runApp(MyApp());
  doWhenWindowReady(() {
    var initialSize = Size(600, 450);
    var win = appWindow;
    win.alignment = Alignment.center;
    win.minSize = initialSize;
    win.size = initialSize;
    win.title = "Switch colors Flutter app";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: Scaffold(body: AppBody()));
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  int _skinNumber = 0;
  AppSkin _skin = skins[0];

  void switchSkin() {
    _skinNumber++;
    _skinNumber = (_skinNumber % skins.length);
    setState(() {
      _skin = skins[_skinNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppColors(
        colors: _skin,
        child: WindowBorder(
            color: _skin.border,
            width: 1,
            child: Row(children: [
              LeftSide(),
              RightSide(
                onButtonPressed: switchSkin,
              )
            ])));
  }
}

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colors = AppColors.of(context).colors;
    return SizedBox(
        width: 200,
        child: Container(
            color: colors.sidebar,
            child: Column(
              children: [WindowTitleBarBox(child: MoveWindow())],
            )));
  }
}

class RightSide extends StatelessWidget {
  final VoidCallback onButtonPressed;
  RightSide({Key key, this.onButtonPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var colors = AppColors.of(context).colors;
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.backgroundStart, colors.backgroundEnd],
                  stops: [0.0, 1.0]),
            ),
            child: Column(children: [
              RightSideTopArea(),
              Expanded(
                child: Center(
                    child: RoundedFlatButton(
                        text: 'Switch', onPressed: () => onButtonPressed())),
              )
            ])));
  }
}

class RightSideTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
        child: Row(children: [Expanded(child: MoveWindow()), WindowButtons()]));
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colors = AppColors.of(context).colors;
    var buttonColors = WindowButtonColors(
        iconNormal: colors.icon,
        iconMouseDown: colors.iconMouseDown,
        iconMouseOver: colors.iconMouseOver,
        mouseDown: colors.buttonMouseDown,
        mouseOver: colors.buttonMouseOver);
    var closeButtonColors = WindowButtonColors(
        mouseOver: Colors.red[700],
        mouseDown: Colors.red[900],
        iconNormal: colors.icon,
        iconMouseOver: Colors.white);

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

class RoundedFlatButton extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final Color mouseOverColor;
  final Color textColor;
  final String text;

  RoundedFlatButton(
      {Key key,
      this.onPressed,
      this.color,
      this.mouseOverColor,
      this.textColor,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      hoverColor: mouseOverColor ?? Colors.grey[800],
      color: color ?? Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: Text(text ?? 'Button',
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}
