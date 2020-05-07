import 'dart:collection';

import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/models/entry.dart';
import 'package:characters/characters.dart';

class EntryRepository {
  const EntryRepository({this.db});

  final DBProvider db;

  Stream<List<Entry>> searchForChinese(String rawQuery) async* {
    final cleanedQuery = cleanChineseSearchQuery(rawQuery);

    // Characters and detected phrases in the query are converted to simplified Chinese
    // The actual search is then only performed in simplified Chinese
    // Otherwise the permutations for the search index explode
    final List<String> queries = await getSimplifiedQueries(cleanedQuery);

    List<Entry> results = <Entry>[];

    results = await db.searchInDictBySimplifiedChinese(cleanedQuery, cleanedQuery + 'z');

    if (results.isNotEmpty) {
      results = LinkedHashSet<Entry>.from(results).toList();
      yield results;
    }

    for (var iQuery = 0; iQuery < queries.length; iQuery++) {
      final query = queries[iQuery];
      results
          .addAll(await db.searchInDictBySimplifiedChinese(query, query + 'z'));

      if (results.isNotEmpty) {
        results = LinkedHashSet<Entry>.from(results).toList();
        yield results;
      }
    }

    // If nothing found so far, search for exact matches in traditional Chinese
    // That can happen when a character is not in openCC (Example: 廐, as of data_v0.4)
    if (results.isEmpty) {
      results.addAll(await db.searchInDictByTraditionalChinese(
          cleanedQuery, cleanedQuery + 'z'));
    }

    yield LinkedHashSet<Entry>.from(results).toList();
  }

  Future<List<Entry>> searchForEnglish(String rawQuery) async {
    final cleanedQuery = cleanEnglishSearchQuery(rawQuery);

    List<Entry> results = await db.searchInDictByEnglish(cleanedQuery);

    return results;
  }

  String cleanChineseSearchQuery(String query) {
    return query
        .toLowerCase()
        .replaceAll('ü', 'u:')
        .replaceAll('v', 'u:')
        .replaceAll(' ', '');
  }

  String cleanEnglishSearchQuery(String query) {
    return query.trim().toLowerCase();
  }

  Future<List<String>> getSimplifiedQueries(String originalQuery) async {
    // Check if the input matches a phrase that can be converted to simplified
    List<String> queries =
        (await db.getTraditionalToSimplifiedPhrases(originalQuery)).split(' ');

    // If there was no match with a phrase check if characters in the query can be converted to simplified characters
    if (queries.length == 1 && queries[0] == '') {
      queries = await _getTraditionalToSimpliedCharacters(originalQuery);
    }

    return queries;
  }

  Future<List<String>> _getTraditionalToSimpliedCharacters(
      String originalQuery) async {
    List<String> queries = [''];

    // Iterate over the query and check whether characters can be converted to simplified Chinese
    for (var iCharacter = 0;
        iCharacter < originalQuery.characters.length;
        iCharacter++) {
      // Use the characters package to handle surrogate pairs
      final character =
          originalQuery.characters.skip(iCharacter).take(1).toString();

      final conversions =
          (await db.getTraditionalToSimplifiedCharacters(character)).split(',');

      if (conversions.length > 0 && conversions[0] != '') {
        final tmpQueries = <String>[];

        // If there is more than one possible conversion generate new query variants
        for (var i = 0; i < conversions.length; i++) {
          queries.forEach((query) {
            tmpQueries.add(query + conversions[i]);
          });
        }

        queries = tmpQueries;
      } else {
        // If there is no possible conversion just add the character
        for (var i = 0; i < queries.length; i++) {
          queries[i] = queries[i] + character;
        }
      }
    }

    return queries;
  }
}
