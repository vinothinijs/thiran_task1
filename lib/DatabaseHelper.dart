import 'package:flutter_email/transactions_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'transactions.db';
  static const _databaseVersion = 1;

  static const table = 'transactions';

  static const columnId = 'TransID';
  static const columnDescription = 'TransDesc';
  static const columnStatus = 'TransStatus';
  static const columnDateTime = 'TransDateTime';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    await deleteDatabaseIfExists(); // Delete existing database if it exists

    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnDescription TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnDateTime TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertProduct(Transactions transactions) async {
    Database db = await instance.database;
    return await db.insert(table, transactions.toMap());
  }

  Future<List<Transactions>> getErrorRecords() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result =
        await db.query(table, where: 'TransStatus = ?', whereArgs: ["Error"]);
    return result.map((map) => Transactions.fromMap(map)).toList();
  }

  Future<void> deleteDatabaseIfExists() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    if (await databaseExists(path)) {
      await deleteDatabase(path);
    }
  }
}
