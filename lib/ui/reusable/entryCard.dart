import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:provider/provider.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;

  EntryCard(this.entry);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = Provider.of<AppPreferences>(context);

    final formattedDefinitions = formatDefinitions(entry.definitions, prefs.chineseMode, prefs.intonationMode);

    TextSpan definitions = TextSpan(children: []);

    if (formattedDefinitions.isEmpty) {
      definitions = TextSpan(text: AppStrings.noDefinitionFound, style: TextStyle(fontStyle: FontStyle.italic));
    }
    else {
      for (var iDefinition = 0; iDefinition < formattedDefinitions.length; iDefinition++) {
        definitions.children.add(TextSpan(text: (iDefinition + 1).toString() + ' ', style: TextStyle(fontWeight: FontWeight.bold)));
        definitions.children.add(formattedDefinitions[iDefinition]);
        if (iDefinition < formattedDefinitions.length - 1) {
          definitions.children.add(TextSpan(text: ' '));
        }
      }
    }

    return Card(
      color: theme.backgroundColor,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            mediumPadding, tinyPadding, mediumPadding, tinyPadding),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                    Text.rich(
                      definitions,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: mediumPadding-2),
                child: (entry.hsk != 7 && prefs.showHskLabels)
                    ? Text.rich(TextSpan(
                        text: 'HSK ' + entry.hsk.toString(),
                        style: TextStyle(decoration: TextDecoration.underline)))
                    : Text.rich(TextSpan(text: '         ')),
              )
            ]),
      ),
    );
  }
}
