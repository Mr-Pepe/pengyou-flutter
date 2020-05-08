import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/ui/dictionary/search/dictionarySearchView.dart';
import 'package:pengyou/ui/settings/baseSettings.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey<NavigatorState>();

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  DictionarySearchViewModel dictionarySearchViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            DictionarySearchView(),
            BaseSettings(),
          ],
        ),
      ),
    );
  }
}
