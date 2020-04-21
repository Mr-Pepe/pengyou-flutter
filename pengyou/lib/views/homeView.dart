import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/icons/custom_icons_icons.dart';
import 'package:pengyou/values/strings.dart';

class HomeView extends StatefulWidget {
  final String title;

  HomeView({this.title});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}