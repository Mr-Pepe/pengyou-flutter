import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:provider/provider.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final int intonationMode;

  EntryCard({this.entry, this.intonationMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      colorHeadword(
                          entry.simplified,
                          entry.pinyin,
                          Provider.of<AppPreferences>(context),
                          Theme.of(context)),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: entryCardHeadwordFontSize),
                    ),
                    Text(
                      formatIntonation(entry.pinyin, intonationMode),
                      style: TextStyle(fontSize: entryCardPinyinFontSize),
                    ),
                  ],
                ),
              ),
              Text.rich(TextSpan(
                  text: 'HSK ' + entry.hsk.toString(),
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
