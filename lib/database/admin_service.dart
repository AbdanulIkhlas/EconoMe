import '../model/login.dart';
import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';

class AdminService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<LoginResponse?> verifyLogin(
      String usernameParam, String passwordParam) async {
    final db = await _dbHelper.checkDB;
    final result = await db!.query(
      'tbl_user',
      where: 'username = ? AND password = ?',
      whereArgs: [usernameParam, passwordParam],
    );
    if (result.isNotEmpty) {
      final id = result.first['id'] as int;
      final username = result.first['username'] as String;
      print(result);
      return LoginResponse(id: id, username: username);
    }
    var databasesPath = await getDatabasesPath();
    print(databasesPath);

    return null;
  }

  Future<bool> register(String username, String password) async {
    final db = await _dbHelper.checkDB;
    final result = await db!.insert(
      DatabaseHelper.userTable,
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(result);
    var databasesPath = await getDatabasesPath();
    print(databasesPath);

    return true;
  }

  Future<bool> checkAdminExist() async {
    final db = await _dbHelper.checkDB;
    final result = await db!.query('tbl_user');
    return result.isNotEmpty;
  }
}
