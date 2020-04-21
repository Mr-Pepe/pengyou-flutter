import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/icons/custom_icons_icons.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/views/dictionary/search/dictionarySearchView.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static List<Widget> _mainViews = <Widget>[
    DictionarySearchView(),
    Text(
      'Settings Placeholder',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: _onItemTapped,
      ),
      body: _mainViews[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}