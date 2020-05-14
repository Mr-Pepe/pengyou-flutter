import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/ui/settings/headwordFormattingSettingsDialog.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
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
                    return HeadwordFormattingSettingsDialog();
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
