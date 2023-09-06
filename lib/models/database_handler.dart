import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/models/item.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'taskmaster.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE items(id TEXT PRIMARY KEY, name TEXT NOT NULL, done INT NOT NULL, date TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  void insertItem(Item item) async {
    final Database db = await initializeDB();
    await db.insert('items', item.toMap());
  }

  void updateItem(Item item) async {
    final Database db = await initializeDB();
    db.update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  void deleteItem(String id) async {
    final Database db = await initializeDB();
    db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Item>> fetchItems() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('items');
    final items = queryResult.map((e) => Item.fromMap(e)).toList();
    return items;
  }
}
