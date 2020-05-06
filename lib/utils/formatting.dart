import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:characters/characters.dart';

List<TextSpan> formatDefinitions(
    String rawDefinitionsString, int chineseMode, int intonationMode) {
  List<TextSpan> formattedDefinitions = <TextSpan>[];

  if (rawDefinitionsString.isNotEmpty) {
    List<String> rawDefinitions = rawDefinitionsString.split('/');

    for (var rawDefinition in rawDefinitions) {
      // Find Chinese words and pinyin and format them according to
      // chineseMode and intonationMode
      // Chinese words are searched by looking for pairs of '§'
      // Pinyin is searched for by looking at pairs of square brackets
      // All this magic can probably be done shorter with some regular expressions
      if (rawDefinition.contains('§') || rawDefinition.contains('[')) {
        String formattedDefinition = '';

        bool inPinyin = false;
        bool inChinese = false;

        String chineseWord = '';
        String pinyin = '';

        String simplified;
        String traditional = '';

        for (var iCharacter = 0;
            iCharacter < rawDefinition.characters.length;
            iCharacter++) {
          // Use the characters package to handle surrogate pairs
          final character =
              rawDefinition.characters.skip(iCharacter).take(1).toString();


          if (inChinese) {

            // If inChinese is true and a § is found, that means the end 
            // of the word is reached
            if (character == '§') {
              if (traditional.isEmpty) {
                simplified = chineseWord;
                traditional = chineseWord;
              }
              else {
                simplified = chineseWord;
              }

              String word;

              switch (chineseMode) {
                case ChineseMode.simplified:
                  word = simplified;
                  break;
                case ChineseMode.simplifiedTraditional:
                  if (simplified == traditional) {
                    word = simplified;
                  }
                  else {
                    word = simplified + '(' + traditional + ')';
                  }
                  break;
                case ChineseMode.traditional:
                  word = traditional;
                  break;
                case ChineseMode.traditionalSimplified:
                  if (simplified == traditional) {
                    word = traditional;
                  }
                  else {
                    word = traditional + '(' + simplified + ')';
                  }
                  break;
                default:
                  word = '';
              }

              // Try to find pinyin corresponding to this word so they can be bundled
              // together for searching the dictionary
              String tmpPinyin = '';
              bool tmpInPinyin = false;

              for (var i = iCharacter+1; i < rawDefinition.characters.length; i++) {
                final tmpCharacter =
                  rawDefinition.characters.skip(i).take(1).toString();

                if (tmpCharacter == ']' || tmpCharacter == '§') {
                  break;
                }
                else if (tmpInPinyin) {
                  tmpPinyin += tmpCharacter.toString();
                }
                else if (tmpCharacter == '[') {
                  tmpInPinyin = true;
                }
              }

              // TODO: Implement links

              formattedDefinition += word;

              simplified = '';
              traditional = '';
              chineseWord = '';
              inChinese = false;
            }
            else if (character == '|') {
              traditional = chineseWord;
              chineseWord = '';
            }
            else {
              chineseWord += character.toString();
            }
          }
          else if (character == '§') {
            inChinese = true;
          }
          else if (inPinyin) {
            if (character == ']') {
              formattedDefinition += formatIntonation(pinyin, intonationMode);
              formattedDefinition += character;
              inPinyin = false;
              pinyin = '';
            }
            else {
              pinyin += character;
            }
          }
          else if (character == '[') {
            inPinyin = true;

            // Add whitespace if necessary
            if (formattedDefinition[formattedDefinition.length-1] != ' ') {
              formattedDefinition += ' ';
            }

            formattedDefinition += character.toString();
          }
          else {
            formattedDefinition += character.toString();
          }
        }

        formattedDefinitions.add(TextSpan(text: formattedDefinition));
      } else {
        formattedDefinitions.add(TextSpan(text: rawDefinition));
      }
    }
  }

  return formattedDefinitions;
}

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

TextSpan colorHeadword(String headword, String pinyin, List<Color> toneColors,
    {double fontSize = 14}) {
  final syllables = pinyin.split(' ');

  TextSpan output =
      TextSpan(children: [], style: TextStyle(fontSize: fontSize));

  // It's not easy to color the headword if there is no clear correspondance
  // between pinyin and headword, so those cases are ignored and returned in
  // regular text color
  if (syllables.length == headword.characters.length) {
    for (var iCharacter = 0;
        iCharacter < headword.characters.length;
        iCharacter++) {
      // Use the characters package to handle surrogate pairs
      final character = headword.characters.skip(iCharacter).take(1).toString();

      final pinyinSyllable = syllables[iCharacter];

      // Don't color digits (e.g., in 2019冠状病毒病 or 3C)
      if (isInt(pinyinSyllable[pinyinSyllable.length - 1]) &&
          !isInt(character)) {
        final tone = int.parse(pinyinSyllable[pinyinSyllable.length - 1]);
        output.children.add(TextSpan(
            text: character, style: TextStyle(color: toneColors[tone - 1])));
      } else {
        output.children.add(TextSpan(
          text: character,
        ));
      }
    }
  } else {
    output.children.add(TextSpan(text: headword));
  }

  return output;
}

TextSpan formatHeadword(
  Entry entry,
  int mode,
  List<Color> colors, {
  bool alternativeDashed = false,
  bool breakLine = false,
  double mainFontSize = 14,
  double alternativeScalingFactor = 1,
}) {
  bool showAlternative = mode == ChineseMode.simplifiedTraditional ||
      mode == ChineseMode.traditionalSimplified;

  TextSpan main;
  TextSpan alternative;

  if (mode == ChineseMode.simplifiedTraditional ||
      mode == ChineseMode.simplified) {
    main = colorHeadword(entry.simplified, entry.pinyin, colors,
        fontSize: mainFontSize);
    alternative = colorHeadword(entry.traditional, entry.pinyin, colors,
        fontSize: mainFontSize * alternativeScalingFactor);
  } else {
    main = colorHeadword(entry.traditional, entry.pinyin, colors,
        fontSize: mainFontSize);
    alternative = colorHeadword(entry.simplified, entry.pinyin, colors,
        fontSize: mainFontSize * alternativeScalingFactor);
  }

  final headword = TextSpan(children: [main]);

  if (showAlternative && main.toPlainText() != alternative.toPlainText()) {
    if (breakLine) {
      headword.children.add(TextSpan(text: '\n'));
    } else {
      headword.children.add(TextSpan(text: ' '));
    }

    if (alternativeDashed) {
      alternative = dashOutAlternative(main, alternative);
    }

    headword.children.addAll([
      TextSpan(
        text: '(',
        style: TextStyle()
            .copyWith(fontSize: mainFontSize * alternativeScalingFactor),
      ),
      alternative,
      TextSpan(
        text: ')',
        style: TextStyle()
            .copyWith(fontSize: mainFontSize * alternativeScalingFactor),
      )
    ]);
  }

  return headword;
}

TextSpan dashOutAlternative(TextSpan main, TextSpan alternative) {
  if (main.children.length == alternative.children.length) {
    for (var iCharacter = 0; iCharacter < main.children.length; iCharacter++) {
      if (main.children[iCharacter].toPlainText() ==
          alternative.children[iCharacter].toPlainText()) {
        alternative.children[iCharacter] =
            TextSpan(text: '-', style: alternative.children[iCharacter].style);
      }
    }
  }
  return alternative;
}
