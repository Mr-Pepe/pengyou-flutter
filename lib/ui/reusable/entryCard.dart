import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;

  EntryCard(this.entry);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.backgroundColor,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(mediumPadding, 0, mediumPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.simplified,
                      textAlign: TextAlign.start,
                      textScaleFactor: 1.5,
                    ),
                    Text(formatIntonation(entry.pinyin, IntonationMode.pinyinMarks)),
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
