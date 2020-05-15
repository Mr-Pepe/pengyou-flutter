import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/ui/reusable/entryList.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';
import 'package:provider/provider.dart';
import 'package:pengyou/values/theme.dart';

class DictionarySearchView extends StatefulWidget {
  @override
  _DictionarySearchViewState createState() => _DictionarySearchViewState();
}

class _DictionarySearchViewState extends State<DictionarySearchView> {
  TextEditingController _textController;
  DictionarySearchViewModel _model;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'ni',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = Provider.of<AppPreferences>(context);

    void changeThings(String asd) {
      prefs.setChineseMode(ChineseMode.traditionalSimplified);
      prefs.setIntonationMode(IntonationMode.pinyinNumbers);
      prefs.setDarkTheme(!prefs.themeIsDark);
    }

    return ChangeNotifierProvider<DictionarySearchViewModel>(
      create: (_) => _model == null
          ? DictionarySearchViewModel(Provider.of(context))
          : _model,
      child: Consumer2<DictionarySearchViewModel, AppPreferences>(
        builder: (context, model, preferences, child) {
          _model = model;

          List<Entry> selectResults(int searchMode) {
            switch (searchMode) {
              case SearchMode.byChineseInDictionary:
                return model.chineseSearchResults;
                break;
              case SearchMode.byEnglishInDictionary:
                return model.englishSearchResults;
                break;
              default:
                return model.chineseSearchResults;
            }
          }

          return Column(
            children: <Widget>[
              AppBar(
                backgroundColor: theme.colorScheme.primary,
                title: Container(
                  padding: EdgeInsets.fromLTRB(
                      largePadding, smallPadding, largePadding, mediumPadding),
                  child: TextField(
                    style: theme.textTheme.bodyText2.copyWith(
                        color: theme.colorScheme.onPrimary, fontSize: 20),
                    controller: _textController,
                    onChanged: model.search,
                    autofocus: true,
                    cursorColor: theme.colorScheme.onPrimary,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.onPrimary, width: 2)),
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.onPrimary, width: 2)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.onPrimary, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(0, materialStandardPadding, 0, 0),
                      suffixIcon: IconButton(
                        onPressed: () => _textController.clear(),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        alignment: Alignment(1, 0),
                        icon: Icon(
                          Icons.clear,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(materialStandardPadding + largePadding, smallPadding,
                      materialStandardPadding + largePadding, mediumPadding),
                  padding: EdgeInsets.fromLTRB(mediumPadding + 5, tinyPadding,
                      mediumPadding + 5, tinyPadding),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.modeSwitchBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => model
                              .setSearchMode(SearchMode.byChineseInDictionary),
                          child: Text(
                            "CHINESE (" +
                                model.chineseSearchResults.length.toString() +
                                ')',
                            style: TextStyle(
                                color: model.searchMode ==
                                        SearchMode.byChineseInDictionary
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primaryVariant),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100),
                        child: GestureDetector(
                          onTap: () => model
                              .setSearchMode(SearchMode.byEnglishInDictionary),
                          child: Text(
                            "ENGLISH (" +
                                model.englishSearchResults.length.toString() +
                                ')',
                            style: TextStyle(
                                color: model.searchMode ==
                                        SearchMode.byEnglishInDictionary
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primaryVariant),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: EntryList(
                    entryList: selectResults(model.searchMode),
                    intonationMode: preferences.intonationMode,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
