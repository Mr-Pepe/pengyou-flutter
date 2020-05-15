import 'package:flutter/material.dart';
import 'package:pengyou/values/colors.dart';

class AppTheme {
  final bool isDark;

  /// Default constructor
  AppTheme({@required this.isDark});

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme textTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.copyWith(bodyText2: TextStyle(fontFamily: 'SourceSansPro')
        );

    ColorScheme colorScheme = ColorScheme(
        // Decide how you want to apply your own custom them, to the MaterialApp
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? darkThemeColorPrimary : lightThemeColorPrimary,
        onPrimary: isDark ? darkThemeColorOnPrimary : lightThemeColorOnPrimary,
        primaryVariant: isDark ? darkThemeColorPrimaryVariant : lightThemeColorPrimaryVariant,
        secondary: isDark ? darkThemeColorSecondary : lightThemeColorSecondary,
        secondaryVariant: isDark ? darkThemeColorSecondary : lightThemeColorSecondary,
        background: isDark ? darkThemeColorBackground : lightThemeColorBackground,
        surface: isDark ? darkThemeColorPrimary : lightThemeColorPrimary,
        onBackground: isDark ? darkThemeGeneralTextColor : lightThemeGeneralTextColor,
        onSurface: isDark ? darkThemeColorOnPrimary : lightThemeColorOnPrimary,
        onError: isDark ? Colors.black : Colors.white,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t =
        ThemeData.from(textTheme: textTheme, colorScheme: colorScheme).copyWith(
      buttonColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      cursorColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      highlightColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      toggleableActiveColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
    );

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}

extension CustomColorScheme on ColorScheme {
  Color get modeSwitchBackgroundColor => modeSwitchColor;
}
