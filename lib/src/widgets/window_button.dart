import 'package:flutter/widgets.dart';

import './mouse_state_builder.dart';
import '../icons/icons.dart';
import '../app_window.dart';

typedef WindowButtonIconBuilder = Widget Function(
    WindowButtonContext buttonContext);
typedef WindowButtonBuilder = Widget Function(
    WindowButtonContext buttonContext, Widget icon);

class WindowButtonContext {
  BuildContext context;
  MouseState mouseState;
  Color backgroundColor;
  Color iconColor;
}

class WindowButtonColors {
  final Color normal;
  final Color mouseOver;
  final Color mouseDown;
  final Color iconNormal;
  final Color iconMouseOver;
  final Color iconMouseDown;
  const WindowButtonColors(
      {this.normal,
      this.mouseOver,
      this.mouseDown,
      @required this.iconNormal,
      this.iconMouseOver,
      this.iconMouseDown});
}

const _defaultButtonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFF404040),
    mouseDown: Color(0xFF202020),
    iconMouseOver: Color(0xFFFFFFFF),
    iconMouseDown: Color(0xFFF0F0F0));

class WindowButton extends StatelessWidget {
  final WindowButtonBuilder builder;
  final WindowButtonIconBuilder iconBuilder;
  final WindowButtonColors colors;
  final bool animate;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  WindowButton(
      {Key key,
      this.colors,
      this.builder,
      @required this.iconBuilder,
      this.padding,
      this.onPressed,
      this.animate = false})
      : super(key: key);

  Color getBackgroundColor(MouseState mouseState) {
    var colors = this.colors ?? _defaultButtonColors;
    if ((mouseState.isMouseDown) && (colors.mouseDown != null))
      return colors.mouseDown;
    if ((mouseState.isMouseOver) && (colors.mouseOver != null))
      return colors.mouseOver;
    return colors.normal;
  }

  Color getIconColor(MouseState mouseState) {
    var colors = this.colors ?? _defaultButtonColors;
    if ((mouseState.isMouseDown) && (colors.iconMouseDown != null))
      return colors.iconMouseDown;
    if ((mouseState.isMouseOver) && (colors.iconMouseOver != null))
      return colors.iconMouseOver;
    return colors.iconNormal;
  }

  @override
  Widget build(BuildContext context) {
    var buttonSize = appWindow.titleBarButtonSize;
    return MouseStateBuilder(
      builder: (context, mouseState) {
        WindowButtonContext buttonContext = WindowButtonContext()
          ..context = context
          ..backgroundColor = getBackgroundColor(mouseState)
          ..iconColor = getIconColor(mouseState);

        var icon = (this.iconBuilder != null)
            ? this.iconBuilder(buttonContext)
            : Container();
        double borderSize = appWindow.borderSize;
        double defaultPadding =
            (appWindow.titleBarHeight - borderSize) / 3 - (borderSize / 2);
        // Used as a tween target if null is returned as a color from getBackgroundColor(), allowing the over state to smoothly transition to transparent.
        var fadeOutColor =
            getBackgroundColor(MouseState()..isMouseOver = true).withOpacity(0);
        var padding = this.padding ?? EdgeInsets.all(defaultPadding);
        var animationMs =
            mouseState.isMouseOver ? (animate ? 100 : 0) : (animate ? 200 : 0);
        Widget iconWithPadding = Padding(padding: padding, child: icon);
        iconWithPadding = AnimatedContainer(
            curve: Curves.easeOut,
            duration: Duration(milliseconds: animationMs),
            color: buttonContext.backgroundColor ?? fadeOutColor,
            child: iconWithPadding);
        var button = (this.builder != null)
            ? this.builder(buttonContext, icon)
            : iconWithPadding;
        return SizedBox(
            width: buttonSize.width, height: buttonSize.height, child: button);
      },
      onPressed: () {
        if (this.onPressed != null) this.onPressed();
      },
    );
  }
}

class MinimizeWindowButton extends WindowButton {
  MinimizeWindowButton(
      {Key key,
      WindowButtonColors colors,
      VoidCallback onPressed,
      bool animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) =>
                MinimizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.minimize());
}

class MaximizeWindowButton extends WindowButton {
  MaximizeWindowButton(
      {Key key,
      WindowButtonColors colors,
      VoidCallback onPressed,
      bool animate})
      : super(
            key: key,
            colors: colors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) =>
                MaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

const _defaultCloseButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Color(0xFFFFFFFF));

class CloseWindowButton extends WindowButton {
  CloseWindowButton(
      {Key key,
      WindowButtonColors colors,
      VoidCallback onPressed,
      bool animate})
      : super(
            key: key,
            colors: colors ?? _defaultCloseButtonColors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) =>
                CloseIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.close());
}
