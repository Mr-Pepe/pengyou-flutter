import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:provider/provider.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final int intonationMode;

  EntryCard(this.entry, this.intonationMode);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.backgroundColor,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(mediumPadding, smallPadding, mediumPadding, smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: colorHeadword(entry.simplified, entry.pinyin, Provider.of<AppPreferences>(context), Theme.of(context)),
                      textAlign: TextAlign.start,
                      textScaleFactor: 1.5,
                    ),
                    Text(formatIntonation(entry.pinyin, intonationMode)),
                  ],
                ),
              ),
              Text(entry.hsk.toString()),
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
