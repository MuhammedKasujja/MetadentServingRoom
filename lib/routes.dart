import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

import 'ui/pages/pages.dart';

class Routes {
  static const String home = "/";
  static const String waitingRoom = "waitingRoom";

  static Route<T> fadeThrough<T>(RouteSettings settings, WidgetBuilder page,
      {int duration = 300}) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (context, animation, secondaryAnimation) => page(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }

  static Route all(RouteSettings settings) =>
      Routes.fadeThrough(settings, (context) {
        switch (settings.name) {
          case Routes.home:
            return const SplashPage();
          case Routes.waitingRoom:
            return const WaitingRoomPage();
          default:
            return const SizedBox.shrink();
        }
      });
}
