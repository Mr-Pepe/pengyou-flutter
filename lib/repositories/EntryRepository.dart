import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/models/entry.dart';

class EntryRepository {
  const EntryRepository({this.db});

  final DBProvider db;

  Future<List<Entry>> searchForChinese(String query) async {
    return await db.searchInDictByChinese(query, query + 'z');
  }

  Future<Entry> searchForEnglish(String query) async {}

  String cleanChineseSearchQuery(String query) {
    return "";
  }
}
