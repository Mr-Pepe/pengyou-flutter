import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/models/strokeOrder.dart';
import 'package:characters/characters.dart';

class StrokeOrderRepository {
  const StrokeOrderRepository({this.db});

  final DBProvider db;

  Future<List<StrokeOrder>> getStrokeOrders(String word) async {
    List<StrokeOrder> strokeOrders = [];

    for (var iCharacter = 0;
        iCharacter < word.characters.length;
        iCharacter++) {
      // Use the characters package to handle surrogate pairs
      final character = word.characters.skip(iCharacter).take(1).toString();

      strokeOrders.add(await db.getStrokeOrder(character.toString()));
    }
    return strokeOrders;
  }
}
