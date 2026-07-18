import 'package:expense_tracker/presentation/Report/reportHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../data/local/database/sqfliteDatabase.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late ReportHelper provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<ReportHelper>();
    getData();
  }

  void getData() async {
    monthsList = provider.checkMonthList();
    if (monthsList.isNotEmpty) {
      await provider.getGraphData(monthsList[0]);
      await provider.getMonthlyTransactions(monthsList[0]);
      await provider.getAmount(monthsList[0]);
      groupList = provider.groupData.entries.toList();
      provider.setLoading();
      setState(() {});
    } else {
      provider.setLoading();
      setState(() {});
    }
  }

  final List<Color> colors = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.amber,
    Colors.teal,
    Colors.grey,
  ];
  final List<String> items = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Others",
  ];
  List<String> monthsList = [];
  List<MapEntry<String, List<Map<String, dynamic>>>> groupList = [];

  @override
  Widget build(BuildContext context) {
    return monthsList.isNotEmpty
        ? Consumer<ReportHelper>(
            builder: (ctx, helper, child) {
              return helper.loading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.07,

                        ///bottom: MediaQuery.of(context).size.width * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.width * 0.13,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: Icon(Icons.arrow_drop_down_sharp),
                                    value: helper.currentValue,
                                    hint: Text("Select Month"),
                                    isExpanded: true,
                                    items: monthsList.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) async {
                                      if (value != null) {
                                        await helper.getMonthlyTransactions(value);
                                        groupList = helper.groupData.entries.toList();
                                        await helper.setCurrentMonth(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.06,
                            ),

                            Text(
                              "Summary",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.03,
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      //elevation: 6,
                                      //shadowColor: Colors.green.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                        color: Colors.white38,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.05,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "INCOME",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.04,
                                                  fontWeight: FontWeight.bold,
                                                  //color: Colors.green[700],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.01,
                                              ),
                                              Text(
                                                "${helper.currency} ${helper.income}",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                  fontWeight: FontWeight.w700,
                                                  //color: Colors.green[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Expanded(
                                    child: Card(
                                      //elevation: 6,
                                      //shadowColor: Colors.red.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                        color: Colors.white38,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.05,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "EXPENSES",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.04,
                                                  fontWeight: FontWeight.bold,
                                                  //color: Colors.red[600],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.01,
                                              ),
                                              Text(
                                                "${helper.currency} ${helper.expense}",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                  fontWeight: FontWeight.w700,
                                                  //color: Colors.red[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.06,
                            ),

                            Text(
                              "CATEGORY BREAKDOWN",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.03,
                            ),

                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: monthsList.isEmpty
                                    ? Center(child: Text("no data"))
                                    : PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value: double.parse(
                                                (helper.getGraphCategory(
                                                          items[0],
                                                        ) *
                                                        100 /
                                                        helper.expense)
                                                    .toStringAsFixed(1),
                                              ),
                                              color: colors[0],
                                              titleStyle: TextStyle(
                                                color: Colors.pink[50],
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.035,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: double.parse(
                                                (helper.getGraphCategory(
                                                          items[1],
                                                        ) *
                                                        100 /
                                                        helper.expense)
                                                    .toStringAsFixed(1),
                                              ),
                                              color: colors[1],
                                              titleStyle: TextStyle(
                                                color: Colors.blueAccent[50],
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.035,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: double.parse(
                                                (helper.getGraphCategory(
                                                          items[2],
                                                        ) *
                                                        100 /
                                                        helper.expense)
                                                    .toStringAsFixed(1),
                                              ),
                                              color: colors[2],
                                              titleStyle: TextStyle(
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.035,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: double.parse(
                                                (helper.getGraphCategory(
                                                          items[3],
                                                        ) *
                                                        100 /
                                                        helper.expense)
                                                    .toStringAsFixed(1),
                                              ),
                                              color: colors[3],
                                              titleStyle: TextStyle(
                                                color: Colors.green[505],
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.035,
                                              ),
                                            ),
                                            PieChartSectionData(
                                              value: double.parse(
                                                (helper.getGraphCategory(
                                                          items[4],
                                                        ) *
                                                        100 /
                                                        helper.expense)
                                                    .toStringAsFixed(1),
                                              ),
                                              color: colors[4],
                                              titleStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.035,
                            ),

                            Card(
                              child: Container(
                                color: Colors.white38,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                  top: MediaQuery.of(context).size.width * 0.03,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Column(
                                  children: List.generate(items.length, (
                                    index,
                                  ) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.025,
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.025,
                                              decoration: BoxDecoration(
                                                color: colors[index],
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.02,
                                            ),
                                            Text(
                                              items[index],
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${helper.getGraphCategory(items[index])}",
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.04,
                                            ),
                                            Text(
                                              "${double.parse((provider.getGraphCategory(items[index]) * 100 / helper.expense).toStringAsFixed(1))}%",
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.033,
                                                fontWeight: FontWeight.w500,
                                                color: colors[index],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.06,
                            ),

                            Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.03,
                            ),

                            Column(
                              children: List.generate(groupList.length, (
                                index,
                              ) {
                                final date = groupList[index].key;
                                final transactions = groupList[index].value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.045,
                                        ),
                                      ),
                                    ),

                                    ...transactions.map((item) {
                                      String category =
                                          item[DatabaseHelper
                                              .TRANSACTION_CATEGORY];

                                      Widget leadingIcon;

                                      switch (category) {
                                        case "Food":
                                          leadingIcon = Icon(
                                            Icons.food_bank_outlined,
                                            color: Colors.pinkAccent,
                                          );
                                          break;

                                        case "Transport":
                                          leadingIcon = Icon(
                                            Icons.directions_bus,
                                            color: Colors.blueAccent,
                                          );
                                          break;

                                        case "Shopping":
                                          leadingIcon = Icon(
                                            Icons.shopping_cart,
                                            color: Colors.amber,
                                          );
                                          break;

                                        case "Bills":
                                          leadingIcon = Icon(
                                            Icons.receipt_long,
                                            color: Colors.teal,
                                          );
                                          break;

                                        case "Salary":
                                          leadingIcon = SvgPicture.asset(
                                            "assets/icons/salary.svg",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                          );
                                          break;

                                        case "Freelance":
                                          leadingIcon = SvgPicture.asset(
                                            "assets/icons/freelance.svg",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                          );
                                          break;

                                        case "Investment":
                                          leadingIcon = SvgPicture.asset(
                                            "assets/icons/investment.svg",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                          );
                                          break;

                                        case "Gift":
                                          leadingIcon = SvgPicture.asset(
                                            "assets/icons/gift.svg",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.06,
                                          );
                                          break;

                                        default:
                                          leadingIcon = Icon(
                                            Icons.category,
                                            color: Colors.grey,
                                          );
                                      }

                                      return ListTile(
                                        leading: leadingIcon,
                                        title: Text(category),
                                        subtitle: Text(
                                          item[DatabaseHelper.NOTE] ?? "",
                                        ),
                                        trailing: Text(
                                          "${helper.currency} ${item[DatabaseHelper.TRANSACTION_AMOUNT]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                item[DatabaseHelper
                                                        .TRANSACTION_TYPE] ==
                                                    "expense"
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          )
        : Center(child: Text("No Previous Monthly Data To Show"));
  }
}
