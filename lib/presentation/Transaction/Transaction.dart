// lib/presentation/Transaction/transaction.dart
import 'package:expense_tracker/presentation/Transaction/transactionHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../data/local/database/sqfliteDatabase.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  late TransactionHelper provider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<TransactionHelper>();
      provider.getCurrency();
      await provider.getData(); // wait for data
      isLoading = false;
      if (mounted) {
        //setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<TransactionHelper>(
      builder: (ctx, helper, child) {
        final groupList = helper.groupData.entries.toList();

        return isLoading
            ? const Center(child: CircularProgressIndicator())
            :Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildButton(context, "All" , 0),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                    _buildButton(context, "Income", 1),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                    _buildButton(context, "Expense", 2),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.1),
              Expanded(
                child: ListView.builder(
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    final date = groupList[index].key;
                    final transactions = groupList[index].value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.045,
                            ),
                          ),
                        ),
                        ...transactions.map((item) {
                          String category = item[DatabaseHelper.TRANSACTION_CATEGORY];

                          Widget leadingIcon;

                          switch (category) {

                            case "Food":
                              leadingIcon = Icon(Icons.food_bank_outlined, color: Colors.pinkAccent);
                              break;

                            case "Transport":
                              leadingIcon = Icon(Icons.directions_bus, color: Colors.blueAccent);
                              break;

                            case "Shopping":
                              leadingIcon = Icon(Icons.shopping_cart, color: Colors.amber);
                              break;

                            case "Bills":
                              leadingIcon = Icon(Icons.receipt_long, color: Colors.teal);
                              break;

                            case "Salary":
                              leadingIcon = SvgPicture.asset("assets/icons/salary.svg",
                                width: MediaQuery.of(context).size.width * 0.06,
                                height: MediaQuery.of(context).size.width * 0.06,);
                              break;

                            case "Freelance":
                              leadingIcon = SvgPicture.asset("assets/icons/freelance.svg",
                                width: MediaQuery.of(context).size.width * 0.06,
                                height: MediaQuery.of(context).size.width * 0.06,);
                              break;

                            case "Investment":
                              leadingIcon = SvgPicture.asset("assets/icons/investment.svg",
                                width: MediaQuery.of(context).size.width * 0.06,
                                height: MediaQuery.of(context).size.width * 0.06,);
                              break;

                            case "Gift":
                              leadingIcon = SvgPicture.asset("assets/icons/gift.svg",
                                width: MediaQuery.of(context).size.width * 0.06,
                                height: MediaQuery.of(context).size.width * 0.06,);
                              break;

                            default:
                              leadingIcon = Icon(Icons.category, color: Colors.grey);
                          }

                          return ListTile(
                            leading: leadingIcon,
                            title: Text(category),
                            subtitle: Text(item[DatabaseHelper.NOTE] ?? ""),
                            trailing: Text(
                              "${helper.currency ?? ""} ${item[DatabaseHelper.TRANSACTION_AMOUNT].toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: item[DatabaseHelper.TRANSACTION_TYPE] == "expense"
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, int value) {
    int isSelected = provider.type;
    return GestureDetector(
      onTap: () async{
        await provider.setTransactioType(value);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            border: Border.all(
              color: value == isSelected
                  ? Colors.purple.shade800
                  : Colors.purple.shade300,
            ),
          borderRadius: BorderRadius.circular(20),
          color: value == isSelected ? Colors.purple[500] : Colors.purple[50]
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w500,
            color: value == isSelected ? Colors.white : Colors.purple[500]
          ),
        ),
      ),
    );
  }
}