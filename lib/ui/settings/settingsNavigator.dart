import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/ui/settings/baseSettings.dart';
import 'package:pengyou/ui/settings/generalAppearanceSettings.dart';

GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey<NavigatorState>();

class SettingsNavigator extends StatefulWidget {
  @override
  _SettingsNavigatorState createState() => _SettingsNavigatorState();
}

class _SettingsNavigatorState extends State<SettingsNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: settingsNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return BaseSettings();
              case '/generalAppearanceSettings':
                return GeneralAppearanceSettings();
              default:
                return Text("Placeholder");
            }
          }
        );
      },
    );
  }
}