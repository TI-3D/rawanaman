import 'package:flutter/material.dart';

class FadeThroughPageRoute extends PageRouteBuilder {
  final Widget page;

  FadeThroughPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeIn));
            final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                    parent: secondaryAnimation, curve: Curves.easeOut));

            return FadeTransition(
              opacity: animation.status == AnimationStatus.forward
                  ? fadeIn
                  : fadeOut,
              child: child,
            );
          },
        );
}
