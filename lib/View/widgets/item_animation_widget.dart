import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ItemAnimationWidget extends StatelessWidget {
  const ItemAnimationWidget({
    super.key,
    required this.controller,
    required this.openBuilder,
    required this.closedBuilder,
  });

  final Widget Function(BuildContext, void Function({Never? returnValue})) openBuilder;
  final Widget Function(BuildContext, void Function()) closedBuilder;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 0.95,
      ).animate(controller),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        closedElevation: 0,
        openElevation: 0,
        closedColor: Theme.of(context).colorScheme.primary,
        openColor: Theme.of(context).colorScheme.primary,
        middleColor: Theme.of(context).colorScheme.primary,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(21.0),
          ),
        ),
        openBuilder: openBuilder,
        closedBuilder: closedBuilder,
      ),
    );
  }
}
