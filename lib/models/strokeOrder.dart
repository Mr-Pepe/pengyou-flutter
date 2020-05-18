import 'package:pengyou/dataSources/appDatabase.dart';

class StrokeOrder {
  int id;
  String character;
  String json;

  StrokeOrder({
    this.id,
    this.character,
    this.json,
  });

  StrokeOrder.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    character = map[columnCharacter];
    json = map[columnJson];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnCharacter: character,
      columnJson: json,
    };
    return map;
  }
}
