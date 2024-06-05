import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = 'LoginDetailsDB.db';
  static const _databaseVersion = 2;

  static const loginDetailsTable = 'LoginDetailsTable';
  static const columnId = '_id';

  static const columnUserName = '_userName';
  static const columnDOB = '_dob';
  static const columnPassword = '_password';
  static const columnEmailId = '_emailId';
  static const columnMobileNO = '_mobileNo';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    print(documentsDirectory);
    print(path);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {

    // create table contact_details_table(_id integer primary key, _name text, _mobileNo text, _emailID text)
    await database.execute('''
          CREATE TABLE $loginDetailsTable (
            $columnId INTEGER PRIMARY KEY,
            $columnUserName TEXT,
            $columnDOB TEXT,
            $columnPassword TEXT,
            $columnEmailId,
            $columnMobileNO TEXT
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async{
    await database.execute('drop table $loginDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertRegisterForm(Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    // select * from contact_details_table;
    return await _db.query(tableName);
  }
  Future<bool> checkLoginCredentials(String userName, String password,
      String dob) async {
    final List<Map<String, dynamic>> result = await _db.query(
      loginDetailsTable,
      where: '$columnUserName = ? AND $columnPassword = ? And $columnDOB = ?',

      whereArgs: [userName, password, dob],
    );

    return result.isNotEmpty;
  }
}