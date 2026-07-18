// lib/data/repositories/fetchDatabaseImp.dart
import '../../domain/repositoriesinterface/databasefetch.dart';
import '../local/database/sqfliteDatabase.dart';

class FetchDatabaseImp implements DatabaseFetch {
  final myDB = DatabaseHelper.instance;

  @override
  Future<bool> addTransaction(
      double amount,
      String type,
      String category,
      String date,
      String? note,
      ) async {
    return await myDB.addTransaction(
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: note,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> dashBoardFetch(String month) async {
    return await myDB.getDashBoardTransactionData(month);
  }

  @override
  Future<List<Map<String, dynamic>>> getTransaction(int value) async{
    return await myDB.getTransaction(value);
  }

  @override
  Future<List<Map<String, dynamic>>> getAmount(String month) {
    return myDB.getAmountData(month);
  }


  @override
  Future<List<Map<String, dynamic>>> getMonthlyTransactions(String month) {
    return myDB.getMonthlyTransactions(month);
  }
}