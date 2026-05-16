import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final double borderWidth;
  final Color color;

  const HelpButton({
    super.key,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.borderWidth = 2,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(color: color, width: borderWidth),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Text(
              '?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: iconSize,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
