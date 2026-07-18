// lib/presentation/dashboardHelper.dart (or wherever it is)
import 'package:flutter/foundation.dart';
import '../../domain/repositoriesinterface/databasefetch.dart';
import '../../domain/repositoriesinterface/fetchprefrence.dart';

class DashboardHelper extends ChangeNotifier {
  final Fetchprefrencedata _repoPref;
  final DatabaseFetch _repoDB;

  String? _name;
  String? _currency;
  double _balance = 0.0;
  double _income = 0.0;
  double _expense = 0.0;
  bool _isLoading = true;

  List<Map<String, dynamic>> _data = [];
  Map<String, double> _categoryMap = {};

  DashboardHelper(this._repoPref, this._repoDB);

  Future<void> getPrefData() async {
    _name = _repoPref.getName();
    _currency = _repoPref.getCurrency();
    _balance = _repoPref.getBalance();
    _income = _repoPref.getIncome();
    _expense = _repoPref.getExpense();
    notifyListeners();
  }

  Future<void> getDB_Data(String month) async {
    _data = await _repoDB.dashBoardFetch(month);
    _categoryMap = {
      for (var e in _data)
        e["transaction_category"]: (e["total"] as num).toDouble()
    };
    notifyListeners();
  }

  bool hasData(){
    return _data.isNotEmpty;
  }

  double getCategoryAmount(String category) {
    return _categoryMap[category] ?? 0.0;
  }

  void setLoading(){
    _isLoading = false;
  }

  String get name => _name ?? "";
  String get currency => _currency ?? "";
  double get balance => _balance;
  double get income => _income;
  double get expense => _expense;
  bool get loading => _isLoading;
  //List<Map<String, dynamic>> get data => _data;
}