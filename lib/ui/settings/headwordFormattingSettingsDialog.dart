import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:provider/provider.dart';

class HeadwordFormattingSettingsDialog extends StatefulWidget {
  @override
  _HeadwordFormattingSettingsDialogState createState() =>
      _HeadwordFormattingSettingsDialogState();
}

class _HeadwordFormattingSettingsDialogState
    extends State<HeadwordFormattingSettingsDialog> {
  AppPreferences prefs;
  List<Color> toneColors;
  int chineseMode;
  bool showAlternative;
  double alternativeScalingFactor;
  bool alternativeDashed;

  final entry = Entry(
      simplified: "妈麻马骂吗", traditional: "媽麻馬罵嗎", pinyin: "ma1 ma2 ma3 ma4 ma5");

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      prefs = Provider.of(context);
      toneColors = prefs.getToneColors();
      chineseMode = prefs.chineseMode;
      alternativeScalingFactor = prefs.alternativeHeadwordScalingFactor;
      alternativeDashed = prefs.alternativeDashed;
      showAlternative = chineseMode == ChineseMode.simplifiedTraditional ||
          chineseMode == ChineseMode.traditionalSimplified;
    }

    final theme = Theme.of(context);

    return SimpleDialog(
      title: Center(
          child: Text.rich(formatHeadword(entry, chineseMode, toneColors,
              mainFontSize: 20,
              alternativeDashed: alternativeDashed,
              alternativeScalingFactor: alternativeScalingFactor))),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(
              materialStandardPadding, 0, materialStandardPadding + 6, 0),
          title: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Text(AppStrings.simplified),
                  value: AppStrings.simplified,
                ),
                DropdownMenuItem(
                  child: Text(AppStrings.traditional),
                  value: AppStrings.traditional,
                )
              ],
              value: chineseMode == ChineseMode.simplified ||
                      chineseMode == ChineseMode.simplifiedTraditional
                  ? AppStrings.simplified
                  : AppStrings.traditional,
              onChanged: (value) {
                setState(() {
                  switch (value) {
                    case AppStrings.simplified:
                      chineseMode = showAlternative
                          ? ChineseMode.simplifiedTraditional
                          : ChineseMode.simplified;
                      break;
                    case AppStrings.traditional:
                      chineseMode = showAlternative
                          ? ChineseMode.traditionalSimplified
                          : ChineseMode.traditional;
                      break;
                    default:
                  }
                });
              },
            ),
          ),
        ),
        SwitchListTile(
          title: Text(AppStrings.showAlternative),
          value: (chineseMode == ChineseMode.simplifiedTraditional ||
                  chineseMode == ChineseMode.traditionalSimplified)
              ? true
              : false,
          onChanged: (val) {
            setState(() {
              showAlternative = val;

              if (val == true) {
                chineseMode = chineseMode == ChineseMode.simplified
                    ? ChineseMode.simplifiedTraditional
                    : ChineseMode.traditionalSimplified;
              } else {
                chineseMode = chineseMode == ChineseMode.traditionalSimplified
                    ? ChineseMode.traditional
                    : ChineseMode.simplified;
              }
            });
          },
        ),
        if (showAlternative == true) ...[
          SwitchListTile(
              title: Text(AppStrings.usePlaceholders),
              value: alternativeDashed ? true : false,
              onChanged: (val) {
                setState(() {
                  alternativeDashed = val;
                });
              }),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(
                materialStandardPadding, 0, materialStandardPadding - 3, 0),
            title: Row(
              children: <Widget>[
                Text(AppStrings.alternativeScaling),
                Expanded(
                  child: Slider(
                    min: 0.3,
                    max: 1.0,
                    value: alternativeScalingFactor,
                    onChanged: (val) {
                      setState(
                        () {
                          alternativeScalingFactor = val;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        Padding(
          padding:
              const EdgeInsets.fromLTRB(0, 8, materialStandardPadding - 6, 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            MaterialButton(
              elevation: 5,
              child: Text(
                AppStrings.cancel,
                style: TextStyle(color: theme.highlightColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              elevation: 5,
              child: Text(
                AppStrings.submit,
                style: TextStyle(color: theme.highlightColor),
              ),
              onPressed: () {
                prefs.setChineseMode(chineseMode);
                prefs.setAlternativeDashed(alternativeDashed);
                prefs.setAlternativeHeadwordScalingFactor(
                    alternativeScalingFactor);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ],
    );
  }
}
