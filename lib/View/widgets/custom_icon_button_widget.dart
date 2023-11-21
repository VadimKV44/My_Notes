import 'package:flutter/material.dart';

class CustomIconButtonWidget extends StatefulWidget {
  const CustomIconButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = 34.0,
    this.topPadding = 10.0,
    this.bottomPadding = 10.0,
    this.leftPadding = 12.0,
    this.rightPadding = 8.0,
  });

  final IconData icon;
  final Function() onTap;
  final double iconSize;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;

  @override
  State<CustomIconButtonWidget> createState() => _CustomIconButtonWidgetState();
}

class _CustomIconButtonWidgetState extends State<CustomIconButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 0.8,
      ).animate(_controller),
      child: InkWell(
        onTap: () {
          _controller.forward();
          Future.delayed(const Duration(milliseconds: 80), () {
            widget.onTap();
            _controller.reverse();
          });
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.topPadding,
              bottom: widget.bottomPadding,
              left: widget.leftPadding,
              right: widget.rightPadding,
            ),
            child: Icon(
              widget.icon,
              color: Theme.of(context).iconTheme.color,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
