import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/values/theme.dart';
import 'package:provider/provider.dart';

class StrokeOrderView extends StatefulWidget {
  @override
  _StrokeOrderViewState createState() => _StrokeOrderViewState();
}

class _StrokeOrderViewState extends State<StrokeOrderView> {
  @override
  Widget build(BuildContext context) {
    final extendedTheme = Provider.of<ExtendedAppTheme>(context);

    return Column(
      children: <Widget>[
        Expanded(
                  child: Center(
            child: Text("asdasd"),
          ),
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: extendedTheme.strokeOrderControlButtonBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(CustomIcons.ic_hide),
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.ic_eraser),
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.ic_play),
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.ic_next),
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.ic_pencil),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
