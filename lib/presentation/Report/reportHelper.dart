import 'package:expense_tracker/data/local/database/sqfliteDatabase.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/repositoriesinterface/databasefetch.dart';
import '../../domain/repositoriesinterface/fetchprefrence.dart';

class ReportHelper extends ChangeNotifier {

  ReportHelper(this._repoPref , this._repoDB);


  final DatabaseFetch _repoDB;
  final Fetchprefrencedata _repoPref;

  double _income = 0.0;
  double _expense = 0.0;
  late List<String> _listOfMonths;
  String? _currentValue;
  Map<String, dynamic> _graphData = {};
  bool _isLoading = true;
  Map<String, List<Map<String, dynamic>>> _groupData = {};

  List<String> checkMonthList(){
    _listOfMonths = _repoPref.getReportMonths();
    if(_listOfMonths.isEmpty){
      _isLoading = false;
      return _listOfMonths;
    }else{
      _currentValue = _listOfMonths[0];
      return _listOfMonths;
    }
  }

  Future<void> setCurrentMonth(String? month) async{
    _currentValue = month;
    await getGraphData(month!);
    await getAmount(month);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getGraphData(String month) async {
    final data = await _repoDB.dashBoardFetch(month);
    _graphData = {
      for (var e in data)
        e["transaction_category"]: (e["total"] as num).toDouble()
    };
  }

  Future<void> getAmount(String month) async{
   final data = await _repoDB.getAmount(month);
   for (final row in data) {
     if (row['type'] == 'expense') {
       _expense = (row['total']).toDouble();
     } else if (row[DatabaseHelper.TRANSACTION_TYPE] == 'income') {
       _income = (row['total']).toDouble();
     }
   }
  }

  Future<void> getMonthlyTransactions(String month) async{
    List<Map<String, dynamic>> data = [];
    data = await _repoDB.getMonthlyTransactions(month);
    _groupData = {};
    for (var transaction in data) {
      // ✅ FIX: use correct column name "Date" (capital D)
      String date = transaction[DatabaseHelper.DATE] ?? "No Date";
      if (_groupData.containsKey(date)) {
        _groupData[date]!.add(transaction);
      } else {
        _groupData[date] = [transaction];
      }
    }
  }


  double getGraphCategory(String category) {
    return _graphData[category] ?? 0.0;
  }

  void setLoading(){
    _isLoading = false;
  }

  String getCurrentMonth(){
    return _repoPref.getCurrentMonth();
  }

  double get expense => _expense;
  double get income => _income;
  String get currency => _repoPref.getCurrency();
  String? get currentValue => _currentValue;
  bool get loading => _isLoading;
  Map<String, List<Map<String, dynamic>>> get groupData => _groupData;
}