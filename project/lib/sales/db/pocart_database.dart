import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'pocart_helper.dart';
import '../../sales/models/products_item.dart';
import '../../mains/utils/logger.dart';

class POCARTDatabase {
  // create global field which is instance for accessing
  static final POCARTDatabase instance = POCARTDatabase._init();

  // create new file for database
  static Database? _database;

  // create private constructor
  POCARTDatabase._init();

  Future<Database> get database async {
    // if the database is not null then return it.
    if (_database != null) return _database!;

    // otherwise we will init it.
    "_initDB called...".log();
    _database = await _initDB(POCARTSHelper.DATABASE_FILE_PATH);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: POCARTSHelper.DATABASE_VERSION, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE ${POCARTSHelper.TABLE_POCARTS} (
      'id' $idType,
      ${POCARTSHelper.productID} $integerType,
      ${POCARTSHelper.productCounter} $integerType,
      ${POCARTSHelper.productPackageSelectedId} $integerType,
      ${POCARTSHelper.productPrice} $doubleType,
      ${POCARTSHelper.productTotal} $doubleType,
      ${POCARTSHelper.productTotalItem} $integerType,
      ${POCARTSHelper.productSubTotal} $doubleType
    )
    ''');
  }

  Future<int> create({
    required Data pocart,
    required int packageSelectId,
    required int totalItem,
    required double subTotal,
  }) async {
    final db = await instance.database;

    final Map<String, dynamic> pocartCreateJson = {};
    pocartCreateJson[POCARTSHelper.productID] = pocart.id;
    pocartCreateJson[POCARTSHelper.productCounter] = pocart.quantity;
    pocartCreateJson[POCARTSHelper.productPackageSelectedId] = packageSelectId;
    pocartCreateJson[POCARTSHelper.productPrice] = pocart.price;
    pocartCreateJson[POCARTSHelper.productTotal] = pocart.total;
    pocartCreateJson[POCARTSHelper.productTotalItem] = totalItem;
    pocartCreateJson[POCARTSHelper.productSubTotal] = subTotal;
    'pocart CreateJson: $pocartCreateJson'.log();

    final status = await db.insert(POCARTSHelper.TABLE_POCARTS, pocartCreateJson);
    return status;
  }

  Future<List<dynamic>> read(int id) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      POCARTSHelper.TABLE_POCARTS,
      columns: POCARTSHelper.values,
      where: '${POCARTSHelper.productID} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;

      var lists = <dynamic>[];
      var data = Data(
        id: int.parse(map[POCARTSHelper.productID].toString()),
        quantity: int.parse(map[POCARTSHelper.productCounter].toString()),
        packages: [Package(id: int.parse(map[POCARTSHelper.productPackageSelectedId].toString()))],
        price: double.parse(map[POCARTSHelper.productPrice].toString()),
        total: double.parse(map[POCARTSHelper.productTotal].toString()),
      );

      lists.add(data);
      lists.add(double.parse(map[POCARTSHelper.productTotalItem])); // push total item
      lists.add(double.parse(map[POCARTSHelper.productSubTotal])); // push subTotal

      return lists;
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<dynamic>> readAll() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(POCARTSHelper.TABLE_POCARTS);
    final List<dynamic> lists = List.from(maps);
    final List<Data> listsData = [];
    Data? data;

    for (int i = 0; i < lists.length; i++) {
      var packageId = lists[i][POCARTSHelper.productPackageSelectedId].toString();
      if (int.parse(packageId).runtimeType == int) {
        data = Data(
          id: int.parse(lists[i][POCARTSHelper.productID].toString()),
          quantity: int.parse(lists[i][POCARTSHelper.productCounter].toString()),
          packages: [Package(id: int.parse(packageId))],
          price: double.parse(lists[i][POCARTSHelper.productPrice].toString()),
          total: double.parse(lists[i][POCARTSHelper.productTotal].toString()),
        );

        listsData.add(data);
      }
    }

    var tmpLists = <dynamic>[];
    if (lists.isNotEmpty) {
      tmpLists.add(listsData); // push product
      tmpLists.add(int.parse(lists[0][POCARTSHelper.productTotalItem].toString())); // push total item
      tmpLists.add(double.parse(lists[0][POCARTSHelper.productSubTotal].toString())); // push subTotal
    }

    return tmpLists;
  }

  Future<int> update({
    required Data updatePOCART,
    required int packageId,
    required int totalItem,
    required double subTotal,
  }) async {
    final db = await instance.database;

    final Map<String, dynamic> pocartUpdateJson = {};
    pocartUpdateJson[POCARTSHelper.productCounter] = updatePOCART.quantity;
    pocartUpdateJson[POCARTSHelper.productPackageSelectedId] = packageId;
    pocartUpdateJson[POCARTSHelper.productPrice] = updatePOCART.price;
    pocartUpdateJson[POCARTSHelper.productTotal] = updatePOCART.total;
    pocartUpdateJson[POCARTSHelper.productTotalItem] = totalItem;
    pocartUpdateJson[POCARTSHelper.productSubTotal] = subTotal;

    return await db.update(
      POCARTSHelper.TABLE_POCARTS,
      pocartUpdateJson,
      where: '${POCARTSHelper.productID} = ?',
      whereArgs: [updatePOCART.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      POCARTSHelper.TABLE_POCARTS,
      where: '${POCARTSHelper.productID} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      POCARTSHelper.TABLE_POCARTS,
    );
  }

  Future<void> close() async {
    final db = await instance.database;

    await db.close();
  }
}
