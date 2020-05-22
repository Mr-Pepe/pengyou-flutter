import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/models/strokeOrder.dart';
import 'package:pengyou/ui/dictionary/wordView/strokeOrderDiagram.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/theme.dart';
import 'package:provider/provider.dart';

class StrokeOrderView extends StatefulWidget {
  @override
  _StrokeOrderViewState createState() => _StrokeOrderViewState();

  StrokeOrderView(this.strokeOrders);

  final List<StrokeOrder> strokeOrders;
}

class _StrokeOrderViewState extends State<StrokeOrderView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extendedTheme = Provider.of<ExtendedAppTheme>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              ...List.generate(widget.strokeOrders.length, (index) => StrokeOrderDiagram(widget.strokeOrders[index].id.toString()))
            ],
          ),
        ),
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: materialStandardPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color:
                          extendedTheme.strokeOrderControlButtonBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(mediumPadding+4, 0, mediumPadding, 0),
                        child: GestureDetector(
                          child: Icon(
                            CustomIcons.ic_hide,
                            size: strokeOrderControlButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: mediumPadding),
                        child: GestureDetector(
                          child: Icon(
                            CustomIcons.ic_eraser,
                            size: strokeOrderControlButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: mediumPadding),
                        child: GestureDetector(
                          child: Icon(
                            CustomIcons.ic_play,
                            size: strokeOrderControlButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: mediumPadding),
                        child: GestureDetector(
                          child: Icon(
                            CustomIcons.ic_next,
                            size: strokeOrderControlButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(mediumPadding, 0, mediumPadding+4, 0),
                        child: GestureDetector(
                          child: Icon(
                            CustomIcons.ic_pencil,
                            size: strokeOrderControlButtonSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
