abstract class Fetchprefrencedata {
  Future<void> setFirstUser();
  Future<void> setName(String name);
  Future<void> setCurrency(String currency);
  Future<void> setBalance(double balance);
  Future<void> setIncome(double income);
  Future<void> setExpense(double expense);

  String getName();
  String getCurrency();
  double getBalance();
  double getIncome();
  double getExpense();
  List<String> getReportMonths();
  String getCurrentMonth();
}