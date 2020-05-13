import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/ui/settings/generalAppearanceSettings.dart';
import 'package:pengyou/values/strings.dart';

class BaseSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
              title: Text(AppStrings.generalAppearance),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GeneralAppearanceSettings()));
              }),
          ListTile(
            title: Text(AppStrings.strokeOrderAnimationAndQuiz),
          ),
          ListTile(
            title: Text(AppStrings.aboutThisApp),
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      height: 0,
      color: Colors.grey,
    );
  }
}
