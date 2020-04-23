import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/appDatabase.dart';

class EntryRepository {

  Future<List<Entry>> searchForChinese(String query) async {
    
    DBProvider db = DBProvider.db;

    return await db.searchInDictByChinese(query, query +'z');
  }

  Future<Entry> searchForEnglish(String query) async {

  }
}