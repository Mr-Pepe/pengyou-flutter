import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/colors.dart';

class MockPrefs extends Mock implements AppPreferences {}

void main() {
  group('Pinyin with tone marks formatting:', () {
    // Test according to https://en.wikipedia.org/wiki/Pinyin#Rules_for_placing_the_tone_mark
    test('Single vowels', () {
      expect(formatIntonation('la1', IntonationMode.pinyinMarks), 'lā');
      expect(formatIntonation('mo2', IntonationMode.pinyinMarks), 'mó');
      expect(formatIntonation('e3', IntonationMode.pinyinMarks), 'ě');
      expect(formatIntonation('mi4', IntonationMode.pinyinMarks), 'mì');
      expect(formatIntonation('le', IntonationMode.pinyinMarks), 'le');
      expect(formatIntonation('shu1', IntonationMode.pinyinMarks), 'shū');
      expect(formatIntonation('nü3', IntonationMode.pinyinMarks), 'nǚ');
    });

    test('Precedence rules', () {
      expect(formatIntonation('hei1', IntonationMode.pinyinMarks), 'hēi');
      expect(formatIntonation('lao3', IntonationMode.pinyinMarks), 'lǎo');
      expect(formatIntonation('lou2', IntonationMode.pinyinMarks), 'lóu');
      expect(formatIntonation('hui4', IntonationMode.pinyinMarks), 'huì');
      expect(formatIntonation('niu2', IntonationMode.pinyinMarks), 'niú');
    });

    test('Edge cases', () {
      expect(formatIntonation('', IntonationMode.pinyinMarks), '');
      expect(formatIntonation('1', IntonationMode.pinyinMarks), '1');
      expect(formatIntonation(':;.1', IntonationMode.pinyinMarks), ':;.1');
    });

    test('Space after comma', () {
      expect(
          formatIntonation('la1 , mo2', IntonationMode.pinyinMarks), 'lā, mó');
    });
  });

  group('Pinyin with tone number notation formatting:', () {
    // Test according to https://en.wikipedia.org/wiki/Pinyin#Rules_for_placing_the_tone_mark
    test('Single syllables', () {
      expect(formatIntonation('la1', IntonationMode.pinyinNumbers), 'la1');
      expect(formatIntonation('mo2', IntonationMode.pinyinNumbers), 'mo2');
      expect(formatIntonation('e3', IntonationMode.pinyinNumbers), 'e3');
      expect(formatIntonation('mi4', IntonationMode.pinyinNumbers), 'mi4');
      expect(formatIntonation('le', IntonationMode.pinyinNumbers), 'le');
      expect(formatIntonation('shu1', IntonationMode.pinyinNumbers), 'shu1');
      expect(formatIntonation('nü3', IntonationMode.pinyinNumbers), 'nü3');
    });

    test('Edge cases', () {
      expect(formatIntonation('', IntonationMode.pinyinNumbers), '');
      expect(formatIntonation('1', IntonationMode.pinyinNumbers), '1');
      expect(formatIntonation(':;.1', IntonationMode.pinyinNumbers), ':;.1');
    });

    test('Space after comma', () {
      expect(formatIntonation('la1 , mo2', IntonationMode.pinyinNumbers),
          'la1, mo2');
    });
  });

  group('Headword coloring:', () {
    final mockPrefs = MockPrefs();
    ThemeData themeData = ThemeData();
    when(mockPrefs.getToneColor(1)).thenReturn(tone1DefaultColor);
    when(mockPrefs.getToneColor(2)).thenReturn(tone2DefaultColor);
    when(mockPrefs.getToneColor(3)).thenReturn(tone3DefaultColor);
    when(mockPrefs.getToneColor(4)).thenReturn(tone4DefaultColor);
    when(mockPrefs.getToneColor(5)).thenReturn(tone5DefaultColor);

    test('Single character coloring', () {
      expect(
        colorHeadword("你", "ni1", mockPrefs, themeData),
        TextSpan(style: themeData.textTheme.body1, children: [
          TextSpan(
              text: '你',
              style:
                  TextStyle(color: tone1DefaultColor))
        ]),
      );
      expect(
        colorHeadword("你", "ni2", mockPrefs, themeData),
        TextSpan(style: themeData.textTheme.body1, children: [
          TextSpan(
              text: '你',
              style:
                  TextStyle(color: tone2DefaultColor))
        ]),
      );
      expect(
        colorHeadword("你", "ni3", mockPrefs, themeData),
        TextSpan(style: themeData.textTheme.body1, children: [
          TextSpan(
              text: '你',
              style:
                  TextStyle(color: tone3DefaultColor))
        ]),
      );
      expect(
        colorHeadword("你", "ni4", mockPrefs, themeData),
        TextSpan(style: themeData.textTheme.body1, children: [
          TextSpan(
              text: '你',
              style:
                  TextStyle(color: tone4DefaultColor))
        ]),
      );
      expect(
        colorHeadword("你", "ni5", mockPrefs, themeData),
        TextSpan(style: themeData.textTheme.body1, children: [
          TextSpan(
              text: '你',
              style:
                  TextStyle(color: tone5DefaultColor))
        ]),
      );
    });

    test('Whole word coloring', () {
      expect(
          colorHeadword(
              "朋友妻不可欺", "peng2 you5 qi1 bu4 ke3 qi1", mockPrefs, themeData),
          TextSpan(
              style:
                  themeData.textTheme.body1,
              children: [
                TextSpan(
                  text: '朋',
                  style: TextStyle(color: tone2DefaultColor),
                ),
                TextSpan(
                  text: '友',
                  style: TextStyle(color: tone5DefaultColor),
                ),
                TextSpan(
                  text: '妻',
                  style: TextStyle(color: tone1DefaultColor),
                ),
                TextSpan(
                  text: '不',
                  style: TextStyle(color: tone4DefaultColor),
                ),
                TextSpan(
                  text: '可',
                  style: TextStyle(color: tone3DefaultColor),
                ),
                TextSpan(
                  text: '欺',
                  style: TextStyle(color: tone1DefaultColor),
                ),
              ]));
    });
  });
}
