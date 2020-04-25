import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/models/entry.dart';

class EntryRepository {
  const EntryRepository({this.db});

  final DBProvider db;

  Future<List<Entry>> searchForChinese(String query) async {
    final cleanedQuery = cleanChineseSearchQuery(query);
    return await db.searchInDictByChinese(cleanedQuery, cleanedQuery + 'z');
  }

  Future<Entry> searchForEnglish(String query) async {}

  String cleanChineseSearchQuery(String query) {
    return query.replaceAll('ü', 'u:').replaceAll('v', 'u:').replaceAll(' ', '').toLowerCase();
  }
}
