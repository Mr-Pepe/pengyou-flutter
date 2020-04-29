import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/ui/reusable/entryList.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';
import 'package:provider/provider.dart';

class DictionarySearchView extends StatefulWidget {
  @override
  _DictionarySearchViewState createState() => _DictionarySearchViewState();
}

class _DictionarySearchViewState extends State<DictionarySearchView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<DictionarySearchViewModel>.value(
      value: DictionarySearchViewModel(Provider.of(context)),
      child: Consumer2<DictionarySearchViewModel, AppPreferences>(
          builder: (context, model, preferences, child) {
        model.search('ni');

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              onChanged: model.search,
              autofocus: true,
              cursorColor: theme.colorScheme.onPrimary,
            ),
          ),
          body: EntryList(
            entryList: model.chineseSearchResults,
            intonationMode: preferences.intonationMode,
          ),
        );
      }),
    );
  }
}
