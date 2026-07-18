// lib/data/local/database/sqfliteDatabase.dart
import 'dart:io';
import 'package:expense_tracker/data/local/prefrenceData/Prefrence.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Table & column constants
  static const String TABLE_NAME = "transactions";
  static const String SERIAL_NUMBER = "S_no";
  static const String TRANSACTION_AMOUNT = "amount";
  static const String TRANSACTION_TYPE = "type";
  static const String TRANSACTION_CATEGORY = "category";
  static const String DATE = "date";
  static const String NOTE = "note";
  static const String MONTH = "month";

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 1,

      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $TABLE_NAME (
            $SERIAL_NUMBER INTEGER PRIMARY KEY AUTOINCREMENT,
            $TRANSACTION_AMOUNT REAL,
            $TRANSACTION_TYPE TEXT,
            $TRANSACTION_CATEGORY TEXT,
            $DATE TEXT,
            $NOTE TEXT,
            $MONTH TEXT
          )
        ''');
      },
    );
  }

  // ✅ Insert transaction
  Future<bool> addTransaction({
    required double amount,
    required String type,
    required String category,
    required String date,
    String? note,
  }) async {
    try {
      final db = await database;

      int result = await db.insert(TABLE_NAME, {
        TRANSACTION_AMOUNT: amount,
        TRANSACTION_TYPE: type,
        TRANSACTION_CATEGORY: category,
        DATE: date,
        NOTE: note ?? "", // FIX: avoid null issue
        MONTH: Prefrence.getCurrentMonth()
      });
      print("Insert successful");
      return result > 0;
    } catch (e) {
      print("Insert error: $e");
      return false;
    }
  }

  // ✅ get group data for the graph
  Future<List<Map<String, dynamic>>> getDashBoardTransactionData(String month) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        $TRANSACTION_CATEGORY AS transaction_category,
        SUM($TRANSACTION_AMOUNT) AS total
      FROM $TABLE_NAME
      WHERE $TRANSACTION_TYPE = 'expense'
      AND $MONTH = '${month}'
      GROUP BY $TRANSACTION_CATEGORY
    ''');
  }

  Future<List<Map<String , dynamic>>> getAmountData(String month) async{
    final db = await database;
    return await db.rawQuery(
      '''
  SELECT $TRANSACTION_TYPE, SUM($TRANSACTION_AMOUNT) AS total
  FROM $TABLE_NAME
  WHERE $MONTH = ?
  GROUP BY $TRANSACTION_TYPE
  ''',
      [month],
    );
  }

  Future<List<Map<String, dynamic>>> getTransaction(int value) async {
    final db = await database;

    if (value == 1) {
      return await db.query(
        TABLE_NAME,
        where: "$TRANSACTION_TYPE = ?",
        whereArgs: ["income"],
        orderBy: "$SERIAL_NUMBER DESC",
      );
    }

    if (value == 2) {
      return await db.query(
        TABLE_NAME,
        where: "$TRANSACTION_TYPE = ?",
        whereArgs: ["expense"],
        orderBy: "$SERIAL_NUMBER DESC",
      );
    }

    // ALL
    return await db.query(
      TABLE_NAME,
      orderBy: "$SERIAL_NUMBER DESC",
    );
  }

  Future<List<Map<String , dynamic>>> getMonthlyTransactions(String month) async{
    final db = await database;
    return await db.query(
      TABLE_NAME,
      where: "$MONTH = ?",
      whereArgs: [month],
      orderBy: "$SERIAL_NUMBER DESC",
    );
  }
}