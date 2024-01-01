import 'package:flutter/material.dart';

class ColorItemWidget extends StatelessWidget {
  const ColorItemWidget({
    super.key,
    required this.onTap,
    required this.color,
    required this.isSelected,
  });

  final void Function() onTap;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(width: 3.0, color: isSelected ? Colors.blue : Colors.grey[400]!),
        ),
      ),
    );
  }
}
