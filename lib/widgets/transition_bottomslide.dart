import 'package:flutter/material.dart';

class SlideScaleTransition extends PageRouteBuilder {
  final Widget page;

  SlideScaleTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation =
                Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
                    CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut));
            final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut));

            return SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );
}
