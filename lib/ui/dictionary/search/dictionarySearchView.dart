import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = Provider.of<AppPreferences>(context);

    var _controller = TextEditingController();

    void changeThings(String asd) {
      prefs.setChineseMode(ChineseMode.traditionalSimplified);
      prefs.setIntonationMode(IntonationMode.pinyinNumbers);
      prefs.setDarkTheme(!prefs.themeIsDark);
    }

    return ChangeNotifierProvider<DictionarySearchViewModel>.value(
      value: DictionarySearchViewModel(Provider.of(context)),
      child: Consumer2<DictionarySearchViewModel, AppPreferences>(
          builder: (context, model, preferences, child) {
        // model.search('ni');

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Container(
                padding: EdgeInsets.fromLTRB(largePadding, smallPadding, largePadding, mediumPadding),
                decoration: BoxDecoration(),
                child: TextField(
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary, fontSize: 20),
                  controller: _controller,
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
                      onPressed: () => _controller.clear(),
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
                            child: Text(
                              "CHINESE (" +
                                  model.chineseSearchResults.length.toString() +
                                  ')',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
                            ),
                          ),
                          Container(
                              alignment: Alignment(1, 0),
                              constraints:
                                  BoxConstraints(minWidth: 112, maxWidth: 112),
                              child: Text(
                                "ENGLISH (" + 0.toString() + ')',
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary),
                              )),
                        ])),
                preferredSize: Size.fromHeight(45),
              ),
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
