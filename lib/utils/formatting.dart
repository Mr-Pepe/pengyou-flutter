import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:characters/characters.dart';

void formatDefinitions() {}

/// Formats pinyin from CEDICT given a desired formatting, like mark or number notation.
///
/// `rawPinyin` is a string of space separated pinyin syllables with trailing tone numbers.
/// The rules for placing tone marks were taken from https://en.wikipedia.org/wiki/Pinyin#Rules_for_placing_the_tone_mark.
String formatIntonation(String rawPinyin, int mode) {
  String formattedPinyin = rawPinyin.replaceAll('u:', 'ü');
  switch (mode) {
    case IntonationMode.pinyinMarks:
      final syllables = formattedPinyin.split(' ').toList();

      for (var iSyllable = 0; iSyllable < syllables.length; iSyllable++) {
        final syllable = syllables[iSyllable];
        if (syllable.isNotEmpty) {
          if (isInt(syllable[syllable.length - 1])) {
            final tone = int.parse(syllable[syllable.length - 1]);

            if (tone >= 1 && tone <= 5) {
              int iVowel = -1;

              for (var iChar = 0; iChar < syllable.length; iChar++) {
                final char = syllable[iChar];

                if (['a', 'e'].contains(char.toLowerCase())) {
                  iVowel = iChar;
                  break;
                } else if (char.toLowerCase() == 'o') {
                  iVowel = iChar;
                  break;
                } else if (['i', 'u', 'ü'].contains(char.toLowerCase())) {
                  iVowel = iChar;
                }
              }

              if (iVowel != -1) {
                // Replace vowel with vowel with tone mark and delete trailing tone number
                final substitute =
                    pinyinToneSubstitutions[syllable[iVowel]][tone - 1];
                syllables[iSyllable] =
                    replaceCharAt(syllable, iVowel, substitute)
                        .substring(0, syllable.length - 1);
              }
            }
          }
        }
      }
      formattedPinyin = syllables.join();
      break;
    case IntonationMode.pinyinNumbers:
      formattedPinyin = formattedPinyin.replaceAll(' , ', ',');
      break;
    default:
      {}
  }

  // Add spaces after commas. First remove existing spaces to avoid double spaces
  return formattedPinyin.replaceAll(', ', ',').replaceAll(',', ', ');
}

const pinyinToneSubstitutions = {
  'e': ['ē', 'é', 'ě', 'è', 'e'],
  'a': ['ā', 'á', 'ǎ', 'à', 'a'],
  'i': ['ī', 'í', 'ǐ', 'ì', 'i'],
  'o': ['ō', 'ó', 'ǒ', 'ò', 'o'],
  'u': ['ū', 'ú', 'ǔ', 'ù', 'u'],
  'ü': ['ǖ', 'ǘ', 'ǚ', 'ǜ', 'ü'],
  'A': ['Ā', 'Á', 'Ǎ', 'À', 'A'],
  'E': ['Ē', 'É', 'Ě', 'È', 'E'],
  'I': ['Ī', 'Í', 'Ĭ', 'Ì', 'I'],
  'O': ['Ō', 'Ó', 'Ǒ', 'Ò', 'O'],
  'U': ['Ū', 'Ú', 'Ǔ', 'Ù', 'U'],
  'Ü': ['Ǖ', 'Ǘ', 'Ǚ', 'Ǜ', 'Ü'],
};

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

bool isInt(String s) {
  if (s == null) {
    return false;
  }
  try {
    return int.parse(s) != null;
  } catch (e) {
    return false;
  }
}

TextSpan colorHeadword(
    String headword, String pinyin, AppPreferences prefs, ThemeData themeData) {
  final syllables = pinyin.split(' ');

  TextSpan output = TextSpan(children: [], style: themeData.textTheme.body1);

  if (syllables.length == headword.characters.length) {
    for (var iCharacter = 0;
        iCharacter < headword.characters.length;
        iCharacter++) {
      // Use the characters package to handle surrogate pairs
      final character = headword.characters.skip(iCharacter).take(1).toString();

      final pinyinSyllable = syllables[iCharacter];

      if (isInt(pinyinSyllable[pinyinSyllable.length - 1]) &&
          !isInt(character)) {
        final tone = int.parse(pinyinSyllable[pinyinSyllable.length - 1]);
        output.children.add(TextSpan(
            text: character,
            style: TextStyle(color: prefs.getToneColor(tone))));
      }
    }
  } else {
    output.children.add(TextSpan(text: headword));
  }

  return output;
}
