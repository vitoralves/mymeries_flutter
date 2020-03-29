import 'package:flutter/material.dart';
import 'package:mymemories/helpers/db_helper.dart';

import '../models/memorie.dart';

class MemorieProvider with ChangeNotifier {
  static const String table = 'memorie';
  DbHelper dbHelper = DbHelper();
  List<Memorie> _memories = [];

  List<Memorie> getMemories() {
    return _memories;
  }

  Future<void> insert(Memorie memorie) async {
    try {
      await dbHelper.insert(table, memorie.toMap());
      await get();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> get() async {
    _memories = [];
    List<Map<String, dynamic>> records = await dbHelper.get(table);
    for (var item in records) {
      Memorie m = Memorie(
        item['id'],
        item['image'],
        item['latitude'],
        item['longitude'],
        item['description'],
        item['formattedAddress'],
      );
      _memories.add(m);
    }
    notifyListeners();
  }

  Memorie getById(int id) {
    return _memories.firstWhere((m) => m.id == id);
  }
}
