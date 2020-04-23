import 'package:pengyou/models/entry.dart';
import 'package:pengyou/views/dictionary/appDatabase.dart';

class EntryRepository {
  
  final chineseResults = <String>[];

  Future<List<Entry>> searchForChinese(String query) async {
    
    DBProvider db = DBProvider.db;

    int id = int.parse(query);

    Entry entry = await db.queryEntryById(id);

    if (entry == null) {
      return <Entry>[];
    }
    else {
      return [entry];
    }
  }

  Future<Entry> searchForEnglish(String query) async {

  }
}