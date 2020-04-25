import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/ui/reusable/entryList.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';
import 'package:provider/provider.dart';

class DictionarySearchView extends StatefulWidget {
  @override
  _DictionarySearchViewState createState() => _DictionarySearchViewState();
}

class _DictionarySearchViewState extends State<DictionarySearchView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DictionarySearchViewModel>.value(
      value: DictionarySearchViewModel(Provider.of(context)),
      child: Consumer<DictionarySearchViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: TextField(
              onChanged: model.search,
              autofocus: true,
            ),
          ),
          body: EntryList(
            entryList: model.chineseSearchResults,
          ),
        ),
      ),
    );
  }
}
