import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ThemeProvider.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.sunny : Icons.nightlight_round,
		color: Colors.amber,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
