import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pengyou/models/entry.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableEntries = 'entries';
final String columnId = 'id';
final String columnSimplified = 'simplified';
final String columnTraditional = 'traditional';
final String columnPinyin = 'pinyin';
final String columnDefinitions = 'definitions';
final String columnPriority = 'priority';
final String columnHsk = 'hsk';
final String columnWordLength = 'word_length';
final String columnPinyinLength = 'pinyin_length';

final String tablePermutations = 'permutations';
final String columnPermutation = 'permutation';
final String columnEntryId = 'entry_id';

final String tableTradToSimplCharacters = 'trad_to_simpl_characters';
// columnId
// columnTraditional
// columnSimplified

final String tableTradToSimplPhrases = 'trad_to_simpl_phrases';
// columnId
// columnTraditional
// columnSimplified

const int MAX_SEARCH_RESULTS = 1001;

class DBProvider {
  final String _databaseName = "data.db";
  final int _databaseVersion = 1;

  // Make this a singleton class
  DBProvider._();
  static final DBProvider db = DBProvider._();

  // Allow only one open connection
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    return await _initDB();
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Get the prepopulated database from the assets folder if not done already
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data =
          await rootBundle.load(join('assets', 'data', _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, version: _databaseVersion);
  }

  Future<List<Entry>> queryEntryById(int id) async {
    Database db = await database;

    List<Map> maps =
        await db.query(tableEntries, where: '$columnId = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return [Entry.fromMap(maps.first)];
    } else {
      return <Entry>[];
    }
  }

  Future<List<Entry>> searchInDictBySimplifiedChinese(
      String lowerString, String upperString) async {
    // This search makes use of the permutations
    Database db = await database;

    List<Map> maps = await db.query(
      tableEntries,
      where:
          '$columnId IN (SELECT DISTINCT $columnEntryId FROM $tablePermutations WHERE $columnPermutation >= ? AND $columnPermutation < ? LIMIT ?)',
      whereArgs: [lowerString, upperString, MAX_SEARCH_RESULTS],
    );

    if (maps.length > 0) {
      return [
        for (var iEntry = 0; iEntry < maps.length; iEntry++)
          Entry.fromMap(maps[iEntry])
      ];
    } else {
      return <Entry>[];
    }
  }

  Future<List<Entry>> searchInDictByTraditionalChinese(
      String lowerString, String upperString) async {
    // This search only searches for matches on the traditional entries
    Database db = await database;

    List<Map> maps = await db.query(
      tableEntries,
      where: '$columnTraditional >= ? AND $columnTraditional < ?',
      whereArgs: [lowerString, upperString],
      limit: MAX_SEARCH_RESULTS,
    );

    if (maps.length > 0) {
      return [
        for (var iEntry = 0; iEntry < maps.length; iEntry++)
          Entry.fromMap(maps[iEntry])
      ];
    } else {
      return <Entry>[];
    }
  }

  Future<String> getTraditionalToSimplifiedCharacters(String query) async {
    Database db = await database;

    List<Map> maps = await db.query(
      tableTradToSimplCharacters,
      columns: [columnSimplified],
      where: 'traditional = ?',
      whereArgs: [query],
    );

    if (maps.length > 0) {
      return maps[0][columnSimplified];
    } else {
      return '';
    }
  }

  Future<String> getTraditionalToSimplifiedPhrases(String query) async {
    Database db = await database;

    List<Map> maps = await db.query(
      tableTradToSimplPhrases,
      columns: [columnSimplified],
      where: '$columnTraditional = ?',
      whereArgs: [query],
    );

    if (maps.length > 0) {
      return maps[0][columnSimplified];
    } else {
      return '';
    }
  }
}
