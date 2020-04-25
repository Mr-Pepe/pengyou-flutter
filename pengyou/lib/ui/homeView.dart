import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/ui/dictionary/search/dictionarySearchView.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static List<Widget> _mainViews = <Widget>[
    ProxyProvider<EntryRepository, DictionarySearchViewModel>(
      update: (context, entryRepository, dictionarySearchViewModel) =>
          DictionarySearchViewModel(entryRepository),
      child: DictionarySearchView(),
    ),
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
