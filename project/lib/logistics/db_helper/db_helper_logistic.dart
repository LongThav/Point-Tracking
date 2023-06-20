import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelperLogistic {
  static const product = 'product';

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'db_helper.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE IF NOT EXISTS $product(id TEXT PRIMARY KEY ,'
            ' poIdName TEXT,'
            ' poStatus TEXT,'
            ' poDateTime TEXT, '
            ' poName TEXT,'
            ' poPhone TEXT,'
            ' poDeliveryAddress TEXT)');
      },
      version: 1,
    );
  }

  // add product
  static Future insert(String table, Map<String, Object> data) async {
    final db = await DBHelperLogistic.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //show product
  static Future<List<Map<String, dynamic>>> showProduct() async {
    final db = await DBHelperLogistic.database();
    var select = await db.query(DBHelperLogistic.product);
    return select;
  }

  //delete product
  static Future<void> deletedById(String table, String columnId, String id) async {
    final db = await DBHelperLogistic.database();
    await db.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }
}
