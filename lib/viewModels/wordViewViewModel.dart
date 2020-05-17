import 'package:flutter/material.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/EntryRepository.dart';

class WordViewViewModel extends ChangeNotifier {
  WordViewViewModel(this._entryRepository, this.entry);

  final EntryRepository _entryRepository;

  final Entry entry;

}