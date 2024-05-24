import '../model/model_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String finacialTable = 'tbl_keuangan';
  final String financialId = 'id';
  final String financialTipe = 'tipe';
  final String financialKet = 'keterangan';
  final String financialJmlUang = 'jml_uang';
  final String financialTgl = 'tanggal';

  final String userTable = 'tbl_user';
  final String userId = 'id';
  final String username = 'username';
  final String password = 'password';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  //cek apakah ada database
  Future<Database?> get checkDB async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database?> _initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'econome.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan field-fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql = '''
    CREATE TABLE $finacialTable (
      $financialId INTEGER PRIMARY KEY, 
      $financialTipe TEXT,
      $financialKet TEXT,
      $financialJmlUang TEXT,
      $financialTgl TEXT
    )
  ''';
    await db.execute(sql);

    var userSql = '''
    CREATE TABLE $userTable (
      $userId INTEGER PRIMARY KEY, 
      $username TEXT,
      $password TEXT
    )
  ''';
    await db.execute(userSql);
  }


  //insert ke database
  Future<int?> saveData(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(finacialTable, modelDatabase.toMap());
  }

  //read data pemasukan
  Future<List?> getDataPemasukan() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery('SELECT * FROM $finacialTable WHERE $financialTipe = ?', ['pemasukan']);
    return result.toList();
  }

  //read data pengeluaran
  Future<List?> getDataPengeluaran() async {
    var dbClient = await checkDB;
    var result = await dbClient!.rawQuery('SELECT * FROM $finacialTable WHERE $financialTipe = ?', ['pengeluaran']);
    return result.toList();
  }

  //read data jumlah pemasukan
  Future<int> getJmlPemasukan() async{
    var dbClient = await checkDB;
    var queryResult = await dbClient!.
    rawQuery('SELECT SUM(jml_uang) AS TOTAL from $finacialTable WHERE $financialTipe = ?', ['pemasukan']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  //read data jumlah pengeluaran
  Future<int> getJmlPengeluaran() async{
    var dbClient = await checkDB;
    var queryResult = await dbClient!.
    rawQuery('SELECT SUM(jml_uang) AS TOTAL from $finacialTable WHERE $financialTipe = ?', ['pengeluaran']);
    int total = int.parse(queryResult[0]['TOTAL'].toString());
    return total;
  }

  //update database pemasukan
  Future<int?> updateDataPemasukan(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(finacialTable, modelDatabase.toMap(),
        where: '$financialId = ? and $financialTipe = ?', whereArgs: [modelDatabase.id, 'pemasukan']);
  }

  //update database pengeluaran
  Future<int?> updateDataPengeluaran(ModelDatabase modelDatabase) async {
    var dbClient = await checkDB;
    return await dbClient!.update(finacialTable, modelDatabase.toMap(),
        where: '$financialId = ? and $financialTipe = ?', whereArgs: [modelDatabase.id, 'pengeluaran']);
  }

  //cek database pemasukan
  Future<int?> cekDataPemasukan() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.
    rawQuery('SELECT COUNT(*) FROM $finacialTable WHERE $financialTipe = ?', ['pemasukan']));
  }

  //cek database pengeluaran
  Future<int?> cekDataPengeluaran() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.
    rawQuery('SELECT COUNT(*) FROM $finacialTable WHERE $financialTipe = ?', ['pengeluaran']));
  }

  //hapus database pemasukan
  Future<int?> deletePemasukan(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.
    delete(finacialTable, where: '$financialId = ? and $financialTipe = ?', whereArgs: [id, 'pemasukan']);
  }

  //hapus database pengeluaran
  Future<int?> deleteDataPengeluaran(int id) async {
    var dbClient = await checkDB;
    return await dbClient!.
    delete(finacialTable, where: '$financialId = ? and $financialTipe = ?', whereArgs: [id, 'pengeluaran']);
  }

}
