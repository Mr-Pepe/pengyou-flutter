import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/theme.dart';
import 'package:pengyou/viewModels/wordViewViewModel.dart';
import 'package:provider/provider.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';

class StrokeOrderView extends StatefulWidget {
  @override
  _StrokeOrderViewState createState() => _StrokeOrderViewState();

  StrokeOrderView(this._strokeOrderAnimationControllers);

  final List<StrokeOrderAnimationController> _strokeOrderAnimationControllers;
}

class _StrokeOrderViewState extends State<StrokeOrderView> {
  PageController _pageController;
  int _selectedIndex = 0;

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
    final theme = Theme.of(context);
    final model = Provider.of<WordViewViewModel>(context);

    return ChangeNotifierProvider<StrokeOrderAnimationController>.value(
      value: widget._strokeOrderAnimationControllers[_selectedIndex],
      child: Consumer<StrokeOrderAnimationController>(
        builder: (context, controller, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  physics: controller.isQuizzing
                      ? NeverScrollableScrollPhysics()
                      : ScrollPhysics(),
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    widget._strokeOrderAnimationControllers.length,
                    (index) => FittedBox(
                      child: StrokeOrderAnimator(
                        widget._strokeOrderAnimationControllers[index],
                      ),
                    ),
                  ),
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                      model.setSelectedStrokeOrder(index);
                    });
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: materialStandardPadding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: extendedTheme
                                .strokeOrderControlButtonBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  mediumPadding + 4, 0, mediumPadding, 0),
                              child: GestureDetector(
                                child: Icon(
                                  controller.showOutline
                                      ? CustomIcons.ic_hide
                                      : CustomIcons.ic_unhide,
                                  size: strokeOrderControlButtonSize,
                                  color: extendedTheme
                                      .strokeOrderControlButtonsEnabled,
                                ),
                                onTap: () {
                                  controller
                                      .setShowOutline(!controller.showOutline);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: mediumPadding),
                              child: GestureDetector(
                                child: Icon(
                                  CustomIcons.ic_eraser,
                                  size: strokeOrderControlButtonSize,
                                  color: extendedTheme
                                      .strokeOrderControlButtonsEnabled,
                                ),
                                onTap: () {
                                  controller.reset();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: mediumPadding),
                              child: GestureDetector(
                                child: Icon(
                                  controller.isAnimating
                                      ? CustomIcons.ic_pause
                                      : CustomIcons.ic_play,
                                  size: strokeOrderControlButtonSize,
                                  color: controller.isQuizzing
                                      ? extendedTheme
                                          .strokeOrderControlButtonsDisabled
                                      : extendedTheme
                                          .strokeOrderControlButtonsEnabled,
                                ),
                                onTap: controller.isQuizzing
                                    ? null
                                    : () {
                                        controller.isAnimating
                                            ? controller.stopAnimation()
                                            : controller.startAnimation();
                                      },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: mediumPadding),
                              child: GestureDetector(
                                child: Icon(
                                  CustomIcons.ic_next,
                                  size: strokeOrderControlButtonSize,
                                  color: controller.isQuizzing
                                      ? extendedTheme
                                          .strokeOrderControlButtonsDisabled
                                      : extendedTheme
                                          .strokeOrderControlButtonsEnabled,
                                ),
                                onTap: controller.isQuizzing
                                    ? null
                                    : () {
                                        controller.nextStroke();
                                      },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  mediumPadding, 0, mediumPadding + 4, 0),
                              child: GestureDetector(
                                child: Icon(
                                  controller.isQuizzing
                                      ? CustomIcons.ic_cancel
                                      : CustomIcons.ic_pencil,
                                  size: strokeOrderControlButtonSize,
                                  color: controller.isQuizzing
                                      ? theme.highlightColor
                                      : extendedTheme
                                          .strokeOrderControlButtonsEnabled,
                                ),
                                onTap: () {
                                  if (!controller.isQuizzing) {
                                    controller.startQuiz();
                                  } else {
                                    controller.stopQuiz();
                                  }
                                },
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
        },
      ),
    );
  }
}
