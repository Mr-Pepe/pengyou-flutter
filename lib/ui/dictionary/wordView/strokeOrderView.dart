import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/values/theme.dart';
import 'package:pengyou/viewModels/wordViewViewModel.dart';
import 'package:provider/provider.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';
import 'package:characters/characters.dart';

class StrokeOrderView extends StatefulWidget {
  @override
  _StrokeOrderViewState createState() => _StrokeOrderViewState();
}

class _StrokeOrderViewState extends State<StrokeOrderView>
    with TickerProviderStateMixin {
  List<StrokeOrderAnimationController> _strokeOrderAnimationControllers;
  PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _strokeOrderAnimationControllers = [];
  }

  @override
  void dispose() {
    for (var controller in _strokeOrderAnimationControllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<AppPreferences>(context);
    final model = Provider.of<WordViewViewModel>(context);

    final strokeOrders = (prefs.chineseMode == ChineseMode.simplified ||
            prefs.chineseMode == ChineseMode.simplifiedTraditional)
        ? model.simplifiedStrokeOrders
        : model.traditionalStrokeOrders;

    if (strokeOrders.isNotEmpty && _strokeOrderAnimationControllers.isEmpty) {
      _strokeOrderAnimationControllers =
          List.generate(strokeOrders.length, (index) {
        if (strokeOrders[index].id == -1) {
          return null;
        } else {
          return StrokeOrderAnimationController(strokeOrders[index].json, this);
        }
      });
    }

    return ChangeNotifierProvider<StrokeOrderAnimationController>.value(
      value: _strokeOrderAnimationControllers[_selectedIndex],
      child: Consumer<StrokeOrderAnimationController>(
        builder: (context, controller, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  physics: controller != null && controller.isQuizzing
                      ? NeverScrollableScrollPhysics()
                      : ScrollPhysics(),
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                      _strokeOrderAnimationControllers.length, (index) {
                    if (_strokeOrderAnimationControllers[index] != null) {
                      return FittedBox(
                        child: StrokeOrderAnimator(
                          _strokeOrderAnimationControllers[index],
                          key: UniqueKey(),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(AppStrings.noStrokesFound +
                            model
                                .getActiveHeadword(prefs.chineseMode)
                                .characters
                                .toList()[_selectedIndex]),
                      );
                    }
                  }),
                  onPageChanged: (index) {
                    setState(() {
                      _strokeOrderAnimationControllers[_selectedIndex]
                          ?.stopAnimation();
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: materialStandardPadding),
                  child: StrokeDiagramControls(controller),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class StrokeDiagramControls extends StatelessWidget {
  const StrokeDiagramControls(
    this.controller, {
    Key key,
  }) : super(key: key);

  final StrokeOrderAnimationController controller;

  @override
  Widget build(BuildContext context) {
    final extendedTheme = Provider.of<ExtendedAppTheme>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: extendedTheme.strokeOrderControlButtonBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    mediumPadding + 4, 0, mediumPadding, 0),
                child: OutlineButton(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: ResetButton(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: PlayButton(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: NextButton(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    mediumPadding, 0, mediumPadding + 4, 0),
                child: QuizButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuizButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _extendedTheme = Provider.of<ExtendedAppTheme>(context);
    final _controller = Provider.of<StrokeOrderAnimationController>(context);
    final _theme = Theme.of(context);
    final model = Provider.of<WordViewViewModel>(context);

    final _controllerAvailable = _controller != null;

    return GestureDetector(
      child: Icon(
        _controllerAvailable && _controller.isQuizzing
            ? CustomIcons.ic_cancel
            : CustomIcons.ic_pencil,
        size: strokeOrderControlButtonSize,
        color: _controllerAvailable
            ? (_controller.isQuizzing
                ? _theme.highlightColor
                : _extendedTheme.strokeOrderControlButtonsEnabled)
            : _extendedTheme.strokeOrderControlButtonsDisabled,
      ),
      onTap: () {
        if (_controllerAvailable && !_controller.isQuizzing) {
          _controller.startQuiz();
          model.setSwipingBlocked(true);
        } else {
          _controller.stopQuiz();
          model.setSwipingBlocked(false);
        }
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _extendedTheme = Provider.of<ExtendedAppTheme>(context);
    final _controller = Provider.of<StrokeOrderAnimationController>(context);

    final _controllerAvailable = _controller != null;

    return GestureDetector(
      child: Icon(
        CustomIcons.ic_next,
        size: strokeOrderControlButtonSize,
        color: _controllerAvailable && !_controller.isQuizzing
            ? _extendedTheme.strokeOrderControlButtonsEnabled
            : _extendedTheme.strokeOrderControlButtonsDisabled,
      ),
      onTap: _controllerAvailable && !_controller.isQuizzing
          ? () {
              _controller.nextStroke();
            }
          : null,
    );
  }
}

class PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _extendedTheme = Provider.of<ExtendedAppTheme>(context);
    final _controller = Provider.of<StrokeOrderAnimationController>(context);
    final _theme = Theme.of(context);

    final _controllerAvailable = _controller != null;

    return GestureDetector(
      child: Icon(
        _controllerAvailable && _controller.isAnimating
            ? CustomIcons.ic_pause
            : CustomIcons.ic_play,
        size: strokeOrderControlButtonSize,
        color: _controllerAvailable && !_controller.isQuizzing
            ? (_controller.isAnimating
                ? _theme.highlightColor
                : _extendedTheme.strokeOrderControlButtonsEnabled)
            : _extendedTheme.strokeOrderControlButtonsDisabled,
      ),
      onTap: _controllerAvailable && !_controller.isQuizzing
          ? () {
              _controller.isAnimating
                  ? _controller.stopAnimation()
                  : _controller.startAnimation();
            }
          : null,
    );
  }
}

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _extendedTheme = Provider.of<ExtendedAppTheme>(context);
    final _controller = Provider.of<StrokeOrderAnimationController>(context);

    return GestureDetector(
      child: Icon(
        CustomIcons.ic_eraser,
        size: strokeOrderControlButtonSize,
        color: _controller != null
            ? _extendedTheme.strokeOrderControlButtonsEnabled
            : _extendedTheme.strokeOrderControlButtonsDisabled,
      ),
      onTap: () {
        _controller?.reset();
      },
    );
  }
}

class OutlineButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _extendedTheme = Provider.of<ExtendedAppTheme>(context);
    final _controller = Provider.of<StrokeOrderAnimationController>(context);

    final _controllerAvailable = _controller != null;

    return GestureDetector(
      child: Icon(
        !_controllerAvailable || _controller.showOutline
            ? CustomIcons.ic_hide
            : CustomIcons.ic_unhide,
        size: strokeOrderControlButtonSize,
        color: _controllerAvailable
            ? _extendedTheme.strokeOrderControlButtonsEnabled
            : _extendedTheme.strokeOrderControlButtonsDisabled,
      ),
      onTap: () {
        _controller?.setShowOutline(!_controller.showOutline);
      },
    );
  }
}
