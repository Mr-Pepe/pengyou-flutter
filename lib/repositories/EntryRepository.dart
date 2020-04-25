import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/models/entry.dart';
import 'package:characters/characters.dart';

class EntryRepository {
  const EntryRepository({this.db});

  final DBProvider db;

  Future<List<Entry>> searchForChinese(String query) async {
    final cleanedQuery = cleanChineseSearchQuery(query);

    // Characters and detected phrases in the query are converted to simplified Chinese
    // The actual search is then only performed in simplified Chinese
    // Otherwise the permutations for the search index explode
    final queries = getSimplifiedQueries(cleanedQuery);

    return await db.searchInDictByChinese(cleanedQuery, cleanedQuery + 'z');
  }

  Future<Entry> searchForEnglish(String query) async {}

  String cleanChineseSearchQuery(String query) {
    return query
        .toLowerCase()
        .replaceAll('ü', 'u:')
        .replaceAll('v', 'u:')
        .replaceAll(' ', '');
  }

  Future<List<String>> getSimplifiedQueries(String originalQuery) async {
    // Check if the input matches a phrase that can be converted to simplified
    List<String> queries = await _getTraditionalToSimplifiedPhrases(originalQuery);


    // If there was no match with a phrase check if characters in the query can be converted to simplified characters
    if (queries.length == 1 && queries[0] == originalQuery) {
      queries = await _getTraditionalToSimpliedCharacters(originalQuery);
    }

    return queries;
  }

  Future<List<String>> _getTraditionalToSimpliedCharacters(String originalQuery) async {
    List<String> queries = [''];

    for (var iCharacter = 0; iCharacter < originalQuery.characters.length; iCharacter++) {
      final character = originalQuery.characters.skip(iCharacter).take(1).toString();

      final conversions = (await db.getTraditionalToSimplifiedCharacters(character)).split(',');

      if (conversions.length > 0 && conversions[0] != '') {
        final tmpQueries = <String>[];

        for (var i = 0; i < conversions.length; i++) {
          queries.forEach((query) {
            tmpQueries.add(query + conversions[i]);
          });
        }

        queries = tmpQueries;
      }
      else {
        for (var i = 0; i < queries.length; i++) {
          queries[i] = queries[i] + character;
        }
      }
    }
    
    return queries;
  }

  Future<List<String>> _getTraditionalToSimplifiedPhrases(String originalQuery) async {
    List<String> queries = (await db.getTraditionalToSimplifiedPhrases(originalQuery)).split(' ');

    if (queries.length == 1 && queries[0] == '') {
      queries = [originalQuery];
    }

    return queries;
  }
}
