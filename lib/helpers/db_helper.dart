import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future<Database> openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'memories.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Memorie (id INTEGER PRIMARY KEY, image TEXT, latitude REAL, longitude REAL, description TEXT, formattedAddress TEXT)');
    });
  }

  Future<void> insert(String table, Map<String, Object> obj) async {
    Database db = await openDb();

    await db.insert(table, obj, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> get(String table) async {
    Database db = await openDb();

    return await db.query(table);
  }
}
