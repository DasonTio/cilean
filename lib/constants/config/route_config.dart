import 'package:cilean/features/auth/auth_view.dart';
import 'package:cilean/features/navigation/navigation_view.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  Route onGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case "/":
            return const NavigationView();
          case "/auth":
            return const AuthView();
          default:
            return const Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text("No Route Available"),
                ),
              ),
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
    );
  }
}
