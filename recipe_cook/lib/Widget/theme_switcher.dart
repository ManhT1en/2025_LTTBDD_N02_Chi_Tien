import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_cook/Provider/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return RotationTransition(turns: animation, child: child);
      },
      child: IconButton(
        key: ValueKey(themeProvider.isDarkMode),
        icon: Icon(
          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: themeProvider.isDarkMode ? Colors.yellow : Colors.grey[700],
        ),
        onPressed: () {
          themeProvider.toggleTheme();
        },
        tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
      ),
    );
  }
}
