import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/ui/dictionary/dictionaryNavigator.dart';
import 'package:pengyou/ui/settings/settingsNavigator.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  DictionarySearchViewModel dictionarySearchViewModel;

  // When pressing the Android system back button does not know from which
  // nested navigator to pop and pops from the root navigator instead, which
  // closes the app. So we catch the button press and see if we can pop from
  // the currently active nested navigator
  Future<bool> _systemBackButtonPressed() {
    List<GlobalKey<NavigatorState>> _navigatorKeys = [
      dictionaryNavigatorKey,
      settingsNavigatorKey,
    ];

    final activeNavigator = _navigatorKeys[_selectedIndex];

    if (activeNavigator != null && activeNavigator.currentState.canPop()) {
      activeNavigator.currentState.pop(activeNavigator.currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).highlightColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.ic_dictionary),
                title: Text(AppStrings.dictionary),
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.ic_settings),
                title: Text(AppStrings.settings),
              )
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              DictionaryNavigator(),
              SettingsNavigator(),
            ],
          ),
        ),
      ),
    );
  }
}
