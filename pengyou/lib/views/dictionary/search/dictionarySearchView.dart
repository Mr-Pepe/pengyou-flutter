import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/views/reusable/entryList.dart';

class DictionarySearchView extends StatefulWidget {
  @override
  DictionarySearchViewState createState() => DictionarySearchViewState();
}

class DictionarySearchViewState extends State<DictionarySearchView> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";
  List<String> searchQueries = <String>[''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchQueryController,
            autofocus: true,
            onChanged: search,
          ),
        ),
        body: EntryList(
          entryList: searchQueries,
        ));
  }

  void search(String query) {
    setState(() {
      searchQueries.add(query);
    });
  }
}
