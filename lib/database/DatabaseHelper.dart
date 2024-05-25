import '../model/financial_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  //inisialisasi beberapa variabel yang dibutuhkan
  static const String finacialTable = 'tbl_keuangan';
  static const String financialId = 'id';
  static const String financialTipe = 'tipe';
  static const String financialKet = 'keterangan';
  static const String financialJmlUang = 'jml_uang';
  static const String financialTgl = 'tanggal';
  static const String financialCreated = 'createdAt';

  static const String userTable = 'tbl_user';
  static const String userId = 'id';
  static const String username = 'username';
  static const String password = 'password';

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
      $financialTgl TEXT,
      $financialCreated TEXT
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
  Future<int?> saveData(FinancialModel financialModel) async {
    var dbClient = await checkDB;
    return await dbClient!.insert(finacialTable, financialModel.toMap());
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

  Future<int?> updateData(FinancialModel financialModel, String type) async {
    var dbClient = await checkDB;
    return await dbClient!.update(finacialTable, financialModel.toMap(),
        where: '$financialId = ? and $financialTipe = ?', whereArgs: [financialModel.id, type]);
  }

  // //cek database pemasukan
  // Future<int?> cekDataPemasukan() async {
  //   var dbClient = await checkDB;
  //   return Sqflite.firstIntValue(await dbClient!.
  //   rawQuery('SELECT COUNT(*) FROM $finacialTable WHERE $financialTipe = ?', ['pemasukan']));
  // }

  // //cek database pengeluaran
  // Future<int?> cekDataPengeluaran() async {
  //   var dbClient = await checkDB;
  //   return Sqflite.firstIntValue(await dbClient!.
  //   rawQuery('SELECT COUNT(*) FROM $finacialTable WHERE $financialTipe = ?', ['pengeluaran']));
  // }

  //cek row dalam database
  Future<int?> cekDataDatabase() async {
    var dbClient = await checkDB;
    return Sqflite.firstIntValue(await dbClient!.
    rawQuery('SELECT COUNT(*) FROM $finacialTable '));
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

  Future<int?> deleteTransaksi(int id, String type) async {
    var dbClient = await checkDB;
    return await dbClient!.
    delete(finacialTable, where: '$financialId = ? and $financialTipe = ?', whereArgs: [id, type]);
  }

}
