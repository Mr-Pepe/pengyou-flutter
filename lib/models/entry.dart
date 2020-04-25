import 'package:pengyou/dataSources/appDatabase.dart';

class Entry {
  int id;
  String simplified;
  String traditional;
  String pinyin;
  double priority;
  int hsk;
  int wordLength;
  int pinyinLength;
  String definitions;

  Entry(
      {this.id,
      this.simplified,
      this.traditional,
      this.pinyin,
      this.priority,
      this.hsk,
      this.wordLength,
      this.pinyinLength,
      this.definitions});

  Entry.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    simplified = map[columnSimplified];
    traditional = map[columnTraditional];
    pinyin = map[columnPinyin];
    priority = map[columnPriority];
    hsk = map[columnHsk];
    wordLength = map[columnWordLength];
    pinyinLength = map[columnPinyinLength];
    definitions = map[columnDefinitions];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnId: id,
      columnSimplified: simplified,
      columnTraditional: traditional,
      columnPinyin: pinyin,
      columnPriority: priority,
      columnHsk: hsk,
      columnWordLength: wordLength,
      columnPinyinLength: pinyinLength,
      columnDefinitions: definitions,
    };
    return map;
  }
}