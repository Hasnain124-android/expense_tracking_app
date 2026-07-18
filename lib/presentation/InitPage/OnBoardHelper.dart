// lib/presentation/OnBoardHelper.dart
import 'package:expense_tracker/domain/repositoriesinterface/databasefetch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/repositoriesinterface/fetchprefrence.dart';

class OnboardProvider extends ChangeNotifier {
  final Fetchprefrencedata _repopref;
  final DatabaseFetch _repodb;

  String _name = "";
  String _selectedCurrency = "Select Currency";
  String _balance = "";

  bool _nameError = false;
  bool _currencyError = false;
  bool _balanceError = false;

  OnboardProvider(this._repopref , this._repodb);

  String get selectedCurrency => _selectedCurrency;
  bool get nameError => _nameError;
  bool get currencyError => _currencyError;
  bool get balanceError => _balanceError;

  void setName(String name) {
    _name = name.trim();
    _nameError = false;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _selectedCurrency = currency;
    _currencyError = false;
    notifyListeners();
  }

  void setBalance(String balance) {
    _balance = balance.trim();
    _balanceError = false;
    notifyListeners();
  }

  Future<bool> validate() async {
    _nameError = false;
    _currencyError = false;
    _balanceError = false;

    if (_name.isEmpty) {
      _nameError = true;
      notifyListeners();
      return false;
    }

    if (_selectedCurrency == "Select Currency") {
      _currencyError = true;
      notifyListeners();
      return false;
    }

    if (_balance.isEmpty) {
      _balanceError = true;
      notifyListeners();
      return false;
    }

    double parsedBalance;
    try {
      parsedBalance = double.parse(_balance);
    } catch (e) {
      _balanceError = true;
      notifyListeners();
      return false;
    }

    await _repopref.setFirstUser();
    await _repopref.setName(_name);
    await _repopref.setCurrency(_selectedCurrency);
    await _repopref.setBalance(parsedBalance);
    await _repodb.addTransaction(parsedBalance, "income", "Others", DateFormat('dd-MM-yy').format(DateTime.now()), "Initial Payment");

    return true;
  }
}