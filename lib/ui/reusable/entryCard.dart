import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:provider/provider.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;

  EntryCard(this.entry);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = Provider.of<AppPreferences>(context);

    return Card(
      color: theme.backgroundColor,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            mediumPadding, smallPadding, mediumPadding, smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      formatHeadword(
                          entry, prefs.chineseMode, prefs.getToneColors(),
                          mainFontSize: entryCardHeadwordFontSize,
                          alternativeScalingFactor:
                              prefs.alternativeHeadwordScalingFactor),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      formatIntonation(entry.pinyin, prefs.intonationMode),
                      style: TextStyle(fontSize: entryCardPinyinFontSize),
                    ),
                  ],
                ),
              ),
              Text.rich(TextSpan(
                  text: (entry.hsk != 7 && prefs.showHskLabels)
                      ? 'HSK ' + entry.hsk.toString()
                      : '',
                  style: TextStyle(decoration: TextDecoration.underline))),
            ]),
            Text(
              entry.definitions,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
