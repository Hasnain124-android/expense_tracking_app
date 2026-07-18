import 'package:expense_tracker/data/local/prefrenceData/Prefrence.dart';
import 'package:flutter/material.dart';
import '../../domain/repositoriesinterface/databasefetch.dart';
import '../../domain/repositoriesinterface/fetchprefrence.dart';
import 'package:intl/intl.dart';

class AddTransactionHelper extends ChangeNotifier{
  final DatabaseFetch _repoDB;
  final Fetchprefrencedata _repoPref;
  String _amount = "";
  String? _selectedCategory = null;
  DateTime _selectedDate = DateTime.now();
  String? _note;
  int _isSelectedType = 0;
  bool _amountError = false;
  bool _categoryError = false;

  AddTransactionHelper(this._repoPref , this._repoDB);


  void setAmount(String amount) {
    _amount = amount;
    _amountError = false;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    _categoryError = false;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setType(int type){
    _isSelectedType = type;
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void resetErrors(){
    _amountError = false;
    _categoryError = false;
  }

  void resetValues() {
    _amount = "";
    _selectedCategory = null;
    _selectedDate = DateTime.now();
    _note = null;
    _isSelectedType = 0;

    _amountError = false;
    _categoryError = false;

    notifyListeners();
  }


  int get selectedType => _isSelectedType;
  String? get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;
  bool get amountError => _amountError;
  bool get categoryError => _categoryError;

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  Future<bool> validate()  async{

    // NAME CHECK
    if (_amount.isEmpty) {
      _amountError = true;
      notifyListeners();
      return false;
    }

    // CURRENCY CHECK
    if (_selectedCategory == null) {
      _categoryError = true;
      notifyListeners();
      return false;
    }

    //CHECK FOR CURRENT MONTH VALIDATION
    DateTime now = DateTime.now();
    String month = DateFormat('MM-yyyy').format(now);
    if(Prefrence.getCurrentMonth() != month){
      List<String> reportList = Prefrence.getReportMonths();
      reportList.add(Prefrence.getCurrentMonth());
      await Prefrence.setReportMonths(reportList);
      await Prefrence.setCurrentMonth(month);
    }

    // SAFE PARSE (prevents crash)
    double parsedBalance;
    try {
      parsedBalance = double.parse(_amount);
    } catch (e) {
      _amountError = true;
      notifyListeners();
      return false;
    }
    String type;
    _isSelectedType == 0 ? type = "expense" : type = "income";

    double balance = _repoPref.getBalance();
    if(_isSelectedType == 0){
      double expense = _repoPref.getExpense();
      await _repoPref.setBalance(balance - parsedBalance);
      await _repoPref.setExpense(expense + parsedBalance);
    }else{
      double income = _repoPref.getIncome();
      await _repoPref.setBalance(balance + parsedBalance);
      await _repoPref.setIncome(income + parsedBalance);
    }
    return await _repoDB.addTransaction(parsedBalance, type, _selectedCategory!,  _formatDate(_selectedDate), _note);
  }


}