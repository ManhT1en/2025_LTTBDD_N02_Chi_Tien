import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback pressed;
  const MyIconButton({
    super.key,
    required this.icon,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        theme.cardColor; // adapts for light/dark
    final iconColor = theme
        .iconTheme
        .color; // ensures contrast on bg
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: bgColor,
        fixedSize: const Size(50, 50),
      ),
      onPressed: pressed,
      icon: Icon(icon, color: iconColor),
    );
  }
}
