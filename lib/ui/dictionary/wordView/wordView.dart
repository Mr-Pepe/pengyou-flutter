import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/ui/dictionary/wordView/definitionsView.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/viewModels/wordViewViewModel.dart';
import 'package:provider/provider.dart';

class WordView extends StatefulWidget {
  @override
  _WordViewState createState() => _WordViewState();

  WordView(this.entry);

  final Entry entry;
}

class _WordViewState extends State<WordView> {
  WordViewViewModel _model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<WordViewViewModel>(create: (_) {
      if (_model == null) {
        final model = WordViewViewModel(
            Provider.of(context), Provider.of(context), widget.entry);
        model.init();
        return model;
      } else {
        return _model;
      }
    }, child: Consumer2<WordViewViewModel, AppPreferences>(
        builder: (context, model, prefs, child) {
      return DefaultTabController(
        length: 3,
        child: Column(children: <Widget>[
          AppBar(
            title: Text(""),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      materialStandardPadding,
                      materialStandardPadding,
                      materialStandardPadding,
                      mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        formatHeadword(model.entry, prefs.chineseMode,
                            prefs.getToneColors(),
                            mainFontSize: wordViewHeadwordFontSize,
                            alternativeScalingFactor:
                                prefs.alternativeHeadwordScalingFactor),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        formatIntonation(
                            model.entry.pinyin, prefs.intonationMode),
                        style: TextStyle(fontSize: wordViewPinyinFontSize),
                      ),
                    ],
                  ),
                ),
              ),
              if (model.entry.hsk != 7 && prefs.showHskLabels)
                Padding(
                  padding: EdgeInsets.fromLTRB(0, materialStandardPadding + 5,
                      materialStandardPadding, 0),
                  child: Text.rich(TextSpan(
                      text: 'HSK ' + model.entry.hsk.toString(),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: wordViewHskFontSize))),
                )
            ],
          ),
          Container(
            constraints: BoxConstraints.expand(height: 36),
            child: TabBar(
                unselectedLabelColor: theme.colorScheme.onBackground,
                labelColor: theme.colorScheme.onBackground,
                indicatorColor: theme.highlightColor,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: AppStrings.definitionsTabTitle),
                  Tab(text: AppStrings.strokeTabTitle),
                  Tab(text: AppStrings.wordsTabTitle),
                ]),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                DefinitionsView(model),
                Icon(Icons.ac_unit),
                Icon(Icons.update),
              ],
            ),
          )
        ]),
      );
    }));
  }
}
