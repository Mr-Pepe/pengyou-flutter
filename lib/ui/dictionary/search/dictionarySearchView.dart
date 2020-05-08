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

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Container(
                padding: EdgeInsets.fromLTRB(
                    largePadding, smallPadding, largePadding, mediumPadding),
                decoration: BoxDecoration(),
                child: TextField(
                  style: theme.textTheme.body1.copyWith(
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
                    contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    suffixIcon: IconButton(
                      onPressed: () => _textController.clear(),
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      alignment: Alignment(1, 0),
                      // iconSize: 24,
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                child: Container(
                    margin: EdgeInsets.fromLTRB(
                        largePadding + 16, 0, largePadding + 16, mediumPadding),
                    padding: EdgeInsets.fromLTRB(mediumPadding + 5,
                        smallPadding, mediumPadding + 5, smallPadding),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.modeSwitchBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                                onTap: () => model.setSearchMode(
                                    SearchMode.byChineseInDictionary),
                                child: Text(
                                  "CHINESE (" +
                                      model.chineseSearchResults.length
                                          .toString() +
                                      ')',
                                  style: TextStyle(
                                      color: model.searchMode ==
                                              SearchMode.byChineseInDictionary
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.primaryVariant),
                                )),
                          ),
                          Container(
                              alignment: Alignment(1, 0),
                              constraints:
                                  BoxConstraints(minWidth: 112, maxWidth: 112),
                              child: GestureDetector(
                                  onTap: () => model.setSearchMode(
                                      SearchMode.byEnglishInDictionary),
                                  child: Text(
                                    "ENGLISH (" +
                                        model.englishSearchResults.length
                                            .toString() +
                                        ')',
                                    style: TextStyle(
                                        color: model.searchMode ==
                                                SearchMode.byEnglishInDictionary
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.primaryVariant),
                                  ))),
                        ])),
                preferredSize: Size.fromHeight(45),
              ),
            ),
          ),
          body: EntryList(
            entryList: selectResults(model.searchMode),
            intonationMode: preferences.intonationMode,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
