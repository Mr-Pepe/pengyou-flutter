import 'package:flutter_test/flutter_test.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/formatting.dart';

void main() {
  group('Pinyin with tone marks formatting', () {
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
      expect(formatIntonation('la1 , mo2', IntonationMode.pinyinMarks), 'lā, mó');
    });
  });
}
