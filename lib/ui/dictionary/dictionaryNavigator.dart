import 'package:flutter/material.dart';
import 'package:pengyou/ui/dictionary/search/dictionarySearchView.dart';

GlobalKey<NavigatorState> dictionaryNavigatorKey = GlobalKey<NavigatorState>();

class DictionaryNavigator extends StatefulWidget {
  @override
  _DictionaryNavigatorState createState() => _DictionaryNavigatorState();
}

class _DictionaryNavigatorState extends State<DictionaryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: dictionaryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return DictionarySearchView();
              }
            });
      },
    );
  }
}