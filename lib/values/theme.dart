import 'package:flutter/material.dart';
import 'package:pengyou/values/colors.dart';

class StandardAppTheme {
  final bool isDark;

  /// Default constructor
  StandardAppTheme({@required this.isDark});

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme textTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.copyWith(
              bodyText1: TextStyle(fontFamily: 'SourceSansPro'),
              bodyText2: TextStyle(fontFamily: 'SourceSansPro'),
              headline1: TextStyle(fontFamily: 'SourceSansPro'),
              headline2: TextStyle(fontFamily: 'SourceSansPro'),
              headline3: TextStyle(fontFamily: 'SourceSansPro'),
              headline4: TextStyle(fontFamily: 'SourceSansPro'),
              headline5: TextStyle(fontFamily: 'SourceSansPro'),
              headline6: TextStyle(fontFamily: 'SourceSansPro'),
              subtitle1: TextStyle(fontFamily: 'SourceSansPro'),
              subtitle2: TextStyle(fontFamily: 'SourceSansPro'),
              caption: TextStyle(fontFamily: 'SourceSansPro'),
              button: TextStyle(fontFamily: 'SourceSansPro'),
              overline: TextStyle(fontFamily: 'SourceSansPro'),
            );

    ColorScheme colorScheme = ColorScheme(
      // Decide how you want to apply your own custom them, to the MaterialApp
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? darkThemeColorPrimary : lightThemeColorPrimary,
      onPrimary: isDark ? darkThemeColorOnPrimary : lightThemeColorOnPrimary,
      primaryVariant:
          isDark ? darkThemeColorPrimaryVariant : lightThemeColorPrimaryVariant,
      secondary: isDark ? darkThemeColorSecondary : lightThemeColorSecondary,
      secondaryVariant:
          isDark ? darkThemeColorSecondary : lightThemeColorSecondary,
      background: isDark ? darkThemeColorBackground : lightThemeColorBackground,
      surface: isDark ? darkThemeColorPrimary : lightThemeColorPrimary,
      onBackground:
          isDark ? darkThemeGeneralTextColor : lightThemeGeneralTextColor,
      onSurface: isDark ? darkThemeColorOnPrimary : lightThemeColorOnPrimary,
      onError: isDark ? Colors.black : Colors.white,
      onSecondary: isDark ? Colors.black : Colors.white,
      error: Colors.red.shade400,
    );

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    return ThemeData.from(textTheme: textTheme, colorScheme: colorScheme)
        .copyWith(
      buttonColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      cursorColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      highlightColor: isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      toggleableActiveColor:
          isDark ? darkThemeColorAccent : lightThemeColorPrimary,
      primaryTextTheme: textTheme,
    );
  }
}

class ExtendedAppTheme {
  final bool isDark;

  Color modeSwitchBackgroundColor;

  /// Default constructor
  ExtendedAppTheme({@required this.isDark}) {
    modeSwitchBackgroundColor =
        isDark ? darkThemeModeSwitchColor : lightThemeModeSwitchColor;
  }
}
