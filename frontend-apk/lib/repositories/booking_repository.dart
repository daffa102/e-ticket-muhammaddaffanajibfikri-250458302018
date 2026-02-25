import '../models/booking.dart';
import 'database_helper.dart';

class BookingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertBooking(Booking booking) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.tableBookings, booking.toMap());
  }

  Future<int> deleteBooking(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableBookings,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Booking>> getAllBookings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableBookings,
      orderBy: 'id DESC',
    );
    return maps.map((map) => Booking.fromMap(map)).toList();
  }
}
