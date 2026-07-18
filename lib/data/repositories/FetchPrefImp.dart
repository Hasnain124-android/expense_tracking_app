import '../../domain/repositoriesinterface/fetchprefrence.dart';
import '../local/prefrenceData/Prefrence.dart';

class Fetchprefimp implements Fetchprefrencedata {

  // -------------------------
  // SETTERS (SAFE IMPLEMENTATION)
  // -------------------------

  @override
  Future<void> setFirstUser() async {
    await Prefrence.setFirstUser();
  }

  @override
  Future<void> setName(String name) async {
    await Prefrence.setName(name);
  }

  @override
  Future<void> setCurrency(String currency) async {
    await Prefrence.setCurrency(currency);
  }

  @override
  Future<void> setBalance(double balance) async {
    await Prefrence.setBalance(balance);
  }

  @override
  Future<void> setIncome(double income) async {
    await Prefrence.setIncome(income);
  }

  @override
  Future<void> setExpense(double expense) async {
    await Prefrence.setExpense(expense);
  }

  // -------------------------
  // GETTERS (SAFE NON-ASYNC)
  // -------------------------

  @override
  String getName() {
    return Prefrence.getName();
  }

  @override
  String getCurrency() {
    return Prefrence.getCurrency();
  }

  @override
  double getBalance() {
    return Prefrence.getBalance();
  }

  @override
  double getIncome() {
    return Prefrence.getIncome();
  }

  @override
  double getExpense() {
    return Prefrence.getExpense();
  }

  @override
  List<String> getReportMonths() {
    return Prefrence.getReportMonths();
  }

  @override
  String getCurrentMonth() {
    return Prefrence.getCurrentMonth();
  }
}