import 'package:flutter/widgets.dart';
import 'package:pengyou/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Workflow for introducing a new preference
// 1: Add preference key
// 2: Initialize the preference if not yet existing
// 3: Create setter. Don't forget to notify listeners!
// 4: Create getter

// Preference keys
// Values are defined in the constants file
// Default value is generally 0 (unless that value is deprecated?)
const String THEME = "theme";
const String CHINESE_MODE = "chinese_mode";
const String INTONATION_MODE = "intonation_mode";
const String TONE1_COLOR = "tone1_color";
const String TONE2_COLOR = "tone2_color";
const String TONE3_COLOR = "tone3_color";
const String TONE4_COLOR = "tone4_color";
const String TONE5_COLOR = "tone5_color";
const String ALTERNATIVE_HEADWORD_SCALING_FACTOR =
    "alternative_headword_scaling_factor";
const String SHOW_HSK_LABELS = "show_hsk_label";

class AppPreferences with ChangeNotifier {
  SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Check that all keys exist
    _prefs.getInt(INTONATION_MODE) ?? _prefs.setInt(INTONATION_MODE, 0);
    _prefs.getInt(TONE1_COLOR) ??
        _prefs.setInt(TONE1_COLOR, tone1DefaultColor.value);
    _prefs.getInt(TONE2_COLOR) ??
        _prefs.setInt(TONE2_COLOR, tone2DefaultColor.value);
    _prefs.getInt(TONE3_COLOR) ??
        _prefs.setInt(TONE3_COLOR, tone3DefaultColor.value);
    _prefs.getInt(TONE4_COLOR) ??
        _prefs.setInt(TONE4_COLOR, tone4DefaultColor.value);
    _prefs.getInt(TONE5_COLOR) ??
        _prefs.setInt(TONE5_COLOR, tone5DefaultColor.value);

    _prefs.getDouble(ALTERNATIVE_HEADWORD_SCALING_FACTOR) ??
        _prefs.setDouble(ALTERNATIVE_HEADWORD_SCALING_FACTOR, 0.8);

    _prefs.getInt(CHINESE_MODE) ?? _prefs.setInt(CHINESE_MODE, 0);

    _prefs.getBool(SHOW_HSK_LABELS) ?? _prefs.setBool(SHOW_HSK_LABELS, true);

    notifyListeners();
  }

  void setIntonationMode(int mode) {
    _prefs.setInt(INTONATION_MODE, mode);
    notifyListeners();
  }

  void setChineseMode(int mode) {
    _prefs.setInt(CHINESE_MODE, mode);
    notifyListeners();
  }

  void setAlternativeHeadwordScalingFactor(double scalingFactor) {
    _prefs.setDouble(ALTERNATIVE_HEADWORD_SCALING_FACTOR, scalingFactor);
    notifyListeners();
  }

  void setShowHskLabels(bool flag) {
    _prefs.setBool(SHOW_HSK_LABELS, flag);
    notifyListeners();
  }

  int get chineseMode => _prefs.getInt(CHINESE_MODE);
  double get alternativeHeadwordScalingFactor =>
      _prefs.getDouble(ALTERNATIVE_HEADWORD_SCALING_FACTOR);

  int get intonationMode => _prefs.getInt(INTONATION_MODE);

  bool get showHskLabels => _prefs.getBool(SHOW_HSK_LABELS);

  List<Color> getToneColors() {
    return [tone1Color, tone2Color, tone3Color, tone4Color, tone5Color];
  }
  Color get tone1Color => Color(_prefs.getInt(TONE1_COLOR));
  Color get tone2Color => Color(_prefs.getInt(TONE2_COLOR));
  Color get tone3Color => Color(_prefs.getInt(TONE3_COLOR));
  Color get tone4Color => Color(_prefs.getInt(TONE4_COLOR));
  Color get tone5Color => Color(_prefs.getInt(TONE5_COLOR));
  Color getToneColor(int tone) {
    Color color;
    switch (tone) {
      case 1:
        color = tone1Color;
        break;
      case 2:
        color = tone2Color;
        break;
      case 3:
        color = tone3Color;
        break;
      case 4:
        color = tone4Color;
        break;
      default:
        color = tone5Color;
    }
    return color;
  }
}
