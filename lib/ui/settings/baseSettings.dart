import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/values/strings.dart';

class BaseSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text(AppStrings.settings),
        ),
        Column(
          children: <Widget>[
            ListTile(
                title: Text(AppStrings.generalAppearance),
                onTap: () {
                  Navigator.pushNamed(context, '/generalAppearanceSettings');
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
      ],
    );
  }

  Divider _buildDivider() {
    return Divider(
      height: 0,
      color: Colors.grey,
    );
  }
}
