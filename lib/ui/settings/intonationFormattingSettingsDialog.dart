import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:provider/provider.dart';

class IntonationFormattingSettingsDialog extends StatefulWidget {
  @override
  _IntonationFormattingSettingsDialogState createState() =>
      _IntonationFormattingSettingsDialogState();
}

class _IntonationFormattingSettingsDialogState
    extends State<IntonationFormattingSettingsDialog> {
  AppPreferences prefs;
  int intonationMode;

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      prefs = Provider.of(context);
      intonationMode = prefs.intonationMode;
    }

    final theme = Theme.of(context);

    return SimpleDialog(
      title: Center(
        child: Text(formatIntonation("ma1 jie2 sao3 bu4 ne5", intonationMode)),
      ),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(
              materialStandardPadding, 0, materialStandardPadding + 6, 0),
          title: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Text(AppStrings.pinyinMarks),
                  value: AppStrings.pinyinMarks,
                ),
                DropdownMenuItem(
                  child: Text(AppStrings.pinyinNumbers),
                  value: AppStrings.pinyinNumbers,
                )
              ],
              value: intonationMode == IntonationMode.pinyinMarks
                  ? AppStrings.pinyinMarks
                  : AppStrings.pinyinNumbers,
              onChanged: (value) {
                setState(() {
                  switch (value) {
                    case AppStrings.pinyinMarks:
                      intonationMode = IntonationMode.pinyinMarks;
                      break;
                    case AppStrings.pinyinNumbers:
                      intonationMode = IntonationMode.pinyinNumbers;
                      break;
                    default:
                  }
                });
              },
            ),
          ),
        ),
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
                prefs.setIntonationMode(intonationMode);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ],
    );
  }
}
