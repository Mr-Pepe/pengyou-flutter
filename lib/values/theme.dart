import 'package:flutter/material.dart';
import 'package:pengyou/values/colors.dart';

class AppTheme {
  final bool isDark;

  /// Default constructor
  AppTheme({@required this.isDark});

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme textTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color textColor = textTheme.body1.color;

    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: lightThemeColorPrimary,
        primaryVariant: lightThemeColorPrimary,
        secondary: lightThemeColorSecondary,
        secondaryVariant: lightThemeColorSecondary,
        background: Colors.white,
        surface: lightThemeColorPrimary,
        onBackground: lightThemeColorPrimary,
        onSurface: lightThemeColorPrimary,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t =
        ThemeData.from(textTheme: textTheme, colorScheme: colorScheme).copyWith(
      buttonColor: lightThemeColorPrimary,
      cursorColor: lightThemeColorPrimary,
      highlightColor: lightThemeColorPrimary,
      toggleableActiveColor: lightThemeColorPrimary,
      accentColor: lightThemeColorAccent,
      indicatorColor: lightThemeColorAccent,
    
    );

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}
