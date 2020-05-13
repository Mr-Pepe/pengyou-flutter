import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:provider/provider.dart';

class GeneralAppearanceSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<AppPreferences>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.generalAppearance),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            value: prefs.themeIsDark ? true : false,
            title: Text(AppStrings.theme),
            onChanged: (val) => prefs.setDarkTheme(val),
          ),
          ListTile(
            title: Text(AppStrings.chineseMode),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return HeadwordFormattingDialog();
                  });
            },
          ),
          ListTile(
            title: Text(AppStrings.intonationMode),
            subtitle: Text(getIntonationModeString(prefs.intonationMode)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  String getIntonationModeString(int mode) {
    switch (mode) {
      case IntonationMode.pinyinMarks:
        return AppStrings.pinyinMarks;
        break;
      case IntonationMode.pinyinNumbers:
        return AppStrings.pinyinNumbers;
        break;
      default:
        return "";
    }
  }
}

class HeadwordFormattingDialog extends StatefulWidget {
  @override
  _HeadwordFormattingDialogState createState() =>
      _HeadwordFormattingDialogState();
}

class _HeadwordFormattingDialogState extends State<HeadwordFormattingDialog> {
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

    return SimpleDialog(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
              child: Text.rich(formatHeadword(entry, chineseMode, toneColors,
                  mainFontSize: entryCardHeadwordFontSize,
                  alternativeDashed: alternativeDashed,
                  alternativeScalingFactor: alternativeScalingFactor))),
        ),
        children: <Widget>[
          ListTile(
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
          if (showAlternative)
            SwitchListTile(
                title: Text(AppStrings.usePlaceholders),
                value: alternativeDashed ? true : false,
                onChanged: (val) {
                  setState(() {
                    alternativeDashed = val;
                  });
                })
          else
            // Omit the onChanged callback to deactivate the switch
            SwitchListTile(
              title: Text(AppStrings.usePlaceholders),
              value: alternativeDashed ? true : false,
              onChanged: null,
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5,
                    child: Text(AppStrings.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    elevation: 5,
                    child: Text(AppStrings.submit),
                    onPressed: () {
                      prefs.setChineseMode(chineseMode);
                      prefs.setAlternativeDashed(alternativeDashed);
                      prefs.setAlternativeHeadwordScalingFactor(alternativeScalingFactor);
                      Navigator.pop(context);
                    },
                  ),
                ]),
          ),
        ]);
  }
}
