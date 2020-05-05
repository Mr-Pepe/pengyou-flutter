import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/colors.dart';

void main() {
  List<Color> toneColors = [tone1DefaultColor, tone2DefaultColor, tone3DefaultColor, tone4DefaultColor, tone5DefaultColor];

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
    test('Single character coloring', () {
      final resultTone1 = colorHeadword("你", "ni1", toneColors);
      final resultTone2 = colorHeadword("你", "ni2", toneColors);
      final resultTone3 = colorHeadword("你", "ni3", toneColors);
      final resultTone4 = colorHeadword("你", "ni4", toneColors);
      final resultTone5 = colorHeadword("你", "ni5", toneColors);
      expect(resultTone1.children[0].style.color, tone1DefaultColor);
      expect(resultTone2.children[0].style.color, tone2DefaultColor);
      expect(resultTone3.children[0].style.color, tone3DefaultColor);
      expect(resultTone4.children[0].style.color, tone4DefaultColor);
      expect(resultTone5.children[0].style.color, tone5DefaultColor);
    });

    test('Whole word coloring', () {
      expect(
          colorHeadword("朋友妻不可欺", "peng2 you5 qi1 bu4 ke3 qi1", toneColors,
              fontSize: 23),
          TextSpan(style: TextStyle().copyWith(fontSize: 23), children: [
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

      expect(
          colorHeadword("3C", "san1 C", toneColors, fontSize: 16),
          TextSpan(style: TextStyle().copyWith(fontSize: 16), children: [
            TextSpan(
              text: '3',
            ),
            TextSpan(
              text: 'C',
            )
          ]));

      expect(
          colorHeadword("三C", "san1 C", toneColors),
          TextSpan(style: TextStyle().copyWith(fontSize: 14), children: [
            TextSpan(
              text: '三',
              style: TextStyle(color: tone1DefaultColor),
            ),
            TextSpan(
              text: 'C',
            )
          ]));
    });
  });

  group('Headword formatting:', () {
    final mockEntry = Entry(
        id: 4300,
        simplified: "事实",
        traditional: "事實",
        pinyin: "shi4 shi2",
        priority: 383.5,
        hsk: 5,
        wordLength: 2,
        pinyinLength: 9,
        definitions: "fact/measure word: §個|个§[ge4]");

    final mockEntry2 = Entry(
    id: 4300,
    simplified: "事实",
    traditional: "事实",
    pinyin: "shi4 shi2",
    priority: 383.5,
    hsk: 5,
    wordLength: 2,
    pinyinLength: 9,
    definitions: "fact/measure word: §個|个§[ge4]");

    test('Simplified', () {
      final result = formatHeadword(
          mockEntry, ChineseMode.simplified, toneColors);
      expect(result.toPlainText(), '事实');
      // Headword coloring should be covered by other unit tests, so it is
      // only checked once here
      expect(result.children[0].children[0].style.color, tone4DefaultColor);
      expect(result.children[0].children[1].style.color, tone2DefaultColor);
    });

    test('Traditional', () {
      expect(
          formatHeadword(
                  mockEntry, ChineseMode.traditional, toneColors)
              .toPlainText(),
          '事實');
    });

    test('Simplified and Traditional', () {
      expect(
          formatHeadword(mockEntry, ChineseMode.simplifiedTraditional,
                  toneColors)
              .toPlainText(),
          '事实 (事實)');
    });

    test('Traditional and Simplified', () {
      expect(
          formatHeadword(mockEntry, ChineseMode.traditionalSimplified,
                  toneColors)
              .toPlainText(),
          '事實 (事实)');
    });

    test('Break line between alternatives', () {
      expect(
          formatHeadword(mockEntry, ChineseMode.simplifiedTraditional,
                  toneColors,
                  breakLine: true)
              .toPlainText(),
          '事实\n(事實)');
    });

    test('Alternative different size', () {
      final result = formatHeadword(
          mockEntry, ChineseMode.simplifiedTraditional, toneColors,
          mainFontSize: 30, alternativeScalingFactor: 0.8);
      expect(result.children[0].style.fontSize, 30);
      for (var iChild = 2; iChild < result.children.length; iChild++) {
        expect(result.children[iChild].style.fontSize, 24);
      }
    });

    test('Alternative different size 2', () {
      final result = formatHeadword(
          mockEntry, ChineseMode.simplifiedTraditional, toneColors, alternativeScalingFactor: 0.6);
      expect(result.children[0].style.fontSize, 14);
      for (var iChild = 2; iChild < result.children.length; iChild++) {
        expect(result.children[iChild].style.fontSize, 14*0.6);
      }
    });

    test('Shows alternative only if different', () {
      final result = formatHeadword(
          mockEntry2, ChineseMode.simplifiedTraditional, toneColors);
      expect(result.toPlainText(), "事实");
    });

    test('Show dashed out alternative', () {
      final result = formatHeadword(
          mockEntry, ChineseMode.simplifiedTraditional, toneColors, alternativeDashed: true);
      expect(result.toPlainText(), "事实 (-實)");
    });
  });
}
