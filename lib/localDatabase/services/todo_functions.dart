import 'package:sqflite/sqflite.dart';
import '../../models/sql_model.dart';
import 'local_database_service.dart';

class TodoFunctions {
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      mobile TEXT, 
      email TEXT, 
      created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
      updated_at INTEGER
    );
  """);
  }

  Future<int> create(
      {required String name,
      required String mobile,
      required String email}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (name, mobile, email, created_at) VALUES (?, ?, ?, ?)''',
      [name, mobile, email, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<SQLModel>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * FROM $tableName ORDER BY COALESCE(mobile,email, updated_at, created_at)''');
    return todos.map((todo) => SQLModel.fromSqfliteDatabase(todo)).toList();
  }

  Future<SQLModel> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database
        .rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return SQLModel.fromSqfliteDatabase(todo.first);
  }

  Future<int> update(
      {required int id, String? name, String? mobile, String? email}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        'name': name,
        'mobile': mobile,
        'email': email,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ? ''', [id]);
  }
}
