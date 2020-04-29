import 'package:flutter/widgets.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Preference keys
// Values are defined in the constants file
// Default value is generally 0 (unless that value is deprecated?)
const String THEME = "theme";
const String CHINESE_MODE = "chinese_mode";
const String INTONATION_MODE = "intonation_mode";

class AppPreferences with ChangeNotifier {

  SharedPreferences _prefs;

  int get intonationMode => _prefs.getInt(INTONATION_MODE) ?? 0;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Check that all keys exist
    _prefs.getInt(INTONATION_MODE) ?? _prefs.setInt(INTONATION_MODE, 0);

    notifyListeners();
  }

  void setIntonationMode(int mode) {
    _prefs.setInt(INTONATION_MODE, mode);

    notifyListeners();
  }
}
