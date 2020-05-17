import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/colors.dart';
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
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(
              materialStandardPadding, 0, materialStandardPadding, 0),
          title: Row(
            children: <Widget>[
              // Tone 1
              Expanded(
                child: RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 0, minHeight: 36.0),
                  child: Text(''),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Color pickerColor = toneColors[0];

                        return ToneColorPicker(
                          pickerColor: pickerColor,
                        );
                      },
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          toneColors[0] = val;
                        });
                      }
                    });
                  },
                  shape: CircleBorder(
                      side: BorderSide(color: theme.colorScheme.onBackground)),
                  fillColor: toneColors[0],
                ),
              ),
              Spacer(),
              // Tone 2
              Expanded(
                child: RawMaterialButton(
                  child: Text(''),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Color pickerColor = toneColors[1];

                        return ToneColorPicker(
                          pickerColor: pickerColor,
                        );
                      },
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          toneColors[1] = val;
                        });
                      }
                    });
                  },
                  shape: CircleBorder(
                      side: BorderSide(color: theme.colorScheme.onBackground)),
                  fillColor: toneColors[1],
                ),
              ),
              Spacer(),
              // Tone 3
              Expanded(
                child: RawMaterialButton(
                  child: Text(''),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Color pickerColor = toneColors[2];

                        return ToneColorPicker(
                          pickerColor: pickerColor,
                        );
                      },
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          toneColors[2] = val;
                        });
                      }
                    });
                  },
                  shape: CircleBorder(
                      side: BorderSide(color: theme.colorScheme.onBackground)),
                  fillColor: toneColors[2],
                ),
              ),
              Spacer(),
              // Tone 4
              Expanded(
                child: RawMaterialButton(
                  child: Text(''),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Color pickerColor = toneColors[3];

                        return ToneColorPicker(
                          pickerColor: pickerColor,
                        );
                      },
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          toneColors[3] = val;
                        });
                      }
                    });
                  },
                  shape: CircleBorder(
                      side: BorderSide(color: theme.colorScheme.onBackground)),
                  fillColor: toneColors[3],
                ),
              ),
              Spacer(),
              // Tone 5
              Expanded(
                child: RawMaterialButton(
                  child: Text(''),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Color pickerColor = toneColors[4];

                        return ToneColorPicker(
                          pickerColor: pickerColor,
                        );
                      },
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          toneColors[4] = val;
                        });
                      }
                    });
                  },
                  shape: CircleBorder(
                      side: BorderSide(color: theme.colorScheme.onBackground)),
                  fillColor: toneColors[4],
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.undo),
                onPressed: () {
                  setState(() {
                    toneColors = [
                      tone1DefaultColor,
                      tone2DefaultColor,
                      tone3DefaultColor,
                      tone4DefaultColor,
                      tone5DefaultColor,
                    ];
                  });
                },
              )
            ],
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
                prefs.setChineseMode(chineseMode);
                prefs.setAlternativeDashed(alternativeDashed);
                prefs.setAlternativeHeadwordScalingFactor(
                    alternativeScalingFactor);
                prefs.setToneColors(toneColors);
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ],
    );
  }
}

class ToneColorPicker extends StatefulWidget {
  final Color pickerColor;

  ToneColorPicker({this.pickerColor});

  @override
  _ToneColorPickerState createState() => _ToneColorPickerState();
}

class _ToneColorPickerState extends State<ToneColorPicker> {
  Color pickerColor;

  @override
  Widget build(BuildContext context) {
    if (pickerColor == null) {
      pickerColor = widget.pickerColor;
    }
    return AlertDialog(
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (newColor) {
              setState(
                () {
                  pickerColor = newColor;
                },
              );
            },
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppStrings.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppStrings.submit),
          onPressed: () {
            Navigator.pop(context, pickerColor);
          },
        ),
      ],
    );
  }
}
