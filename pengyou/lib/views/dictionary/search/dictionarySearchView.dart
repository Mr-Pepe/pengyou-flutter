import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/views/dictionary/appDatabase.dart';
import 'package:pengyou/views/reusable/entryList.dart';


class DictionarySearchView extends StatefulWidget {
  @override
  DictionarySearchViewState createState() => DictionarySearchViewState();
}

class DictionarySearchViewState extends State<DictionarySearchView> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";
  List<Entry> searchResults = <Entry>[];

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
          entryList: searchResults,
        ));
  }

  void search(String query) async {
    DBProvider db = DBProvider.db;

    int id = int.parse(query);

    Entry entry = await db.queryEntryById(id);

    if (entry != null) {
        setState(() {
          searchResults.add(entry);
        });
    }
  }
}