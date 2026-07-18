// lib/domain/repositoriesinterface/databasefetch.dart
abstract class DatabaseFetch {
  Future<bool> addTransaction(
      double amount,
      String type,
      String category,
      String date,
      String? note,
      );
  Future<List<Map<String, dynamic>>> dashBoardFetch(String month);

  Future<List<Map<String, dynamic>>> getTransaction(int value);

  Future<List<Map<String , dynamic>>> getAmount(String month);

  Future<List<Map<String , dynamic>>> getMonthlyTransactions(String month);
}