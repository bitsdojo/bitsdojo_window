import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'screen_one.dart';
import 'screen_three.dart';
import 'screen_two.dart';

class Routes {
  //
  static const String screenOne = 'splash';
  static const String screenTwo = 'loader';
  static const String screenThree = 'login';
  //
  static Route<T> fadeThrough<T>(RouteSettings settings, WidgetBuilder page,
      {int duration = 500}) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (context, animation, secondaryAnimation) => page(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }
  //
}

class AppRouter {
  //
  Route onGenerateRoute(RouteSettings settings) {
    //
    return Routes.fadeThrough(settings, (context) {
      //
      switch (settings.name) {
        case Routes.screenOne:
          return const ScreenOne();

        case Routes.screenTwo:
          return const ScreenTwo();

        case Routes.screenThree:
          return const ScreenThree();

        default:
          return const SizedBox.shrink();
      }
      //
    });
    //
  }
  //
}
