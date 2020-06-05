import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/drawables/custom_icons_icons.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/values/theme.dart';
import 'package:pengyou/viewModels/wordViewViewModel.dart';
import 'package:provider/provider.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';
import 'package:characters/characters.dart';

class StrokeOrderView extends StatelessWidget {
  final List<StrokeOrderAnimationController> _animationControllers;

  const StrokeOrderView(this._animationControllers);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WordViewViewModel>(context);
    final controller = _animationControllers[model.selectedStrokeOrder];

    return Column(
      children: <Widget>[
        Expanded(
          child: StrokeOrderPageView(_animationControllers),
        ),
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: materialStandardPadding),
            child: ChangeNotifierProvider<StrokeOrderAnimationController>.value(
              value: controller,
              child: Consumer<StrokeOrderAnimationController>(
                builder: (context, controller, child) {
                  return StrokeDiagramControls(controller);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}

class StrokeOrderPageView extends StatelessWidget {
  const StrokeOrderPageView(
    this._controllers, {
    Key key,
  }) : super(key: key);

  final List<StrokeOrderAnimationController> _controllers;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WordViewViewModel>(context);
    final prefs = Provider.of<AppPreferences>(context);

    final controller = _controllers[model.selectedStrokeOrder];

    return PageView.builder(
      physics: controller != null && controller.isQuizzing
          ? NeverScrollableScrollPhysics()
          : ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        if (controller != null) {
          return FittedBox(
            child: StrokeOrderAnimator(controller),
          );
        } else {
          return Center(
            child: Text(AppStrings.noStrokesFound +
                model
                    .getActiveHeadword(prefs.chineseMode)
                    .characters
                    .toList()[model.selectedStrokeOrder]),
          );
        }
      },
      onPageChanged: (index) {
        model.setSelectedStrokeOrder(index);
      },
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
        } else {
          _controller.stopQuiz();
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
