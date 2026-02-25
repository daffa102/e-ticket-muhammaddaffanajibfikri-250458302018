import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _dbName = 'eticketing.db';
  static const int _dbversion = 1;
  static const String _tableBookings = 'bookings';

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const String tableBookings = 'bookings';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbversion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tickets (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        location TEXT NOT NULL,
        price INTEGER NOT NULL,
        status TEXT NOT NULL,
        image_url TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableBookings (
        id TEXT PRIMARY KEY,
        ticket_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        total_price INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertTicket(Map<String, dynamic> ticket) async {
    final db = await database;
    await db.insert(_tableBookings, ticket);
  }

  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await database;
    return await db.query(_tableBookings, orderBy: 'createdAt DESC');
  }

  Future<void> updateTicket(Map<String, dynamic> ticket) async {
    final db = await database;
    await db.update(
      _tableBookings,
      ticket,
      where: 'id = ?',
      whereArgs: [ticket['id']],
    );
  }

  Future<void> deleteTicket(int id) async {
    final db = await database;
    await db.delete(_tableBookings, where: 'id = ?', whereArgs: [id]);
  }
}
