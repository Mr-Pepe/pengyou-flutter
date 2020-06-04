import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/models/strokeOrder.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/repositories/strokeOrderRepoitory.dart';

class WordViewViewModel extends ChangeNotifier {
  WordViewViewModel(this._entryRepository, this._strokeOrderRepository, this.entry);

  final EntryRepository _entryRepository;
  final StrokeOrderRepository _strokeOrderRepository;

  final Entry entry;

  List<StrokeOrder> _simplifiedStrokeOrders = <StrokeOrder>[];
  List<StrokeOrder> get simplifiedStrokeOrders => _simplifiedStrokeOrders;

  List<StrokeOrder> _traditionalStrokeOrders = <StrokeOrder>[];
  List<StrokeOrder> get traditionalStrokeOrders => _traditionalStrokeOrders;

  int _selectedStrokeOrder = 0;
  int get selectedStrokeOrder => _selectedStrokeOrder;

  void init() async {
    _simplifiedStrokeOrders = await _strokeOrderRepository.getStrokeOrders(entry.simplified);
    _traditionalStrokeOrders = await _strokeOrderRepository.getStrokeOrders(entry.traditional);

    notifyListeners();
  }

  void setSelectedStrokeOrder(int value) {
    _selectedStrokeOrder = value;
    notifyListeners();
  }
}