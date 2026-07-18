// lib/presentation/dashboard.dart
import 'package:expense_tracker/data/local/prefrenceData/Prefrence.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboardHelper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> items = ["Food", "Transport", "Shopping", "Bills", "Others"];
  final List<Color> colors = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.amber,
    Colors.teal,
    Colors.grey,
  ];


  late DashboardHelper provider = context.read<DashboardHelper>();

  @override
  void initState() {
    super.initState();

    provider = context.read<DashboardHelper>();

    bool shouldLoad = Prefrence.getShouldLoad();

    if (shouldLoad) {
      //Prefrence.setShouldLoad(true);
      getData();
    }
  }

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await provider.getPrefData();
      await provider.getDB_Data(Prefrence.getCurrentMonth());
      provider.setLoading();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return provider.loading ? Center(child: CircularProgressIndicator())
        : Consumer<DashboardHelper>(
      builder: (ctx, helper, child) {
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.1,
            ///bottom: MediaQuery.of(context).size.width * 0.03,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, ${helper.name.toUpperCase()} 👋",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Here's your summary",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.07),
              Card(
                //elevation: 4,
                //shadowColor: Colors.purple.shade200,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.purple[500],
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                        Text(
                          "${helper.currency} ${helper.balance}",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.065,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        //elevation: 6,
                        //shadowColor: Colors.green.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          color: Colors.green[100],
                          child: Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                                Text(
                                  "${helper.currency} ${helper.income}",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Expanded(
                      child: Card(
                        //elevation: 6,
                        //shadowColor: Colors.red.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          color: Colors.red[100],
                          child: Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expenses",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                                Text(
                                  "${helper.currency} ${helper.expense}",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red[700],
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
              SizedBox(height: MediaQuery.of(context).size.width * 0.06),
              Text("This Month", style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: provider.hasData() ?
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                            value: double.parse((provider.getCategoryAmount(items[0]) * 100 / helper.expense).toStringAsFixed(1)),
                            color: colors[0],
                            titleStyle: TextStyle(color: Colors.pink[50], fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035)
                        ),
                        PieChartSectionData(
                            value: double.parse((provider.getCategoryAmount(items[1]) * 100 / helper.expense).toStringAsFixed(1)),
                            color: colors[1],
                            titleStyle: TextStyle(color: Colors.blueAccent[50], fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035)
                        ),
                        PieChartSectionData(
                            value: double.parse((provider.getCategoryAmount(items[2]) * 100 / helper.expense).toStringAsFixed(1)),
                            color: colors[2],
                            titleStyle: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035)
                        ),
                        PieChartSectionData(
                            value: double.parse((provider.getCategoryAmount(items[3]) * 100 / helper.expense).toStringAsFixed(1)),
                            color: colors[3],
                            titleStyle: TextStyle(color: Colors.green[505], fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035)
                        ),
                        PieChartSectionData(
                            value: double.parse((provider.getCategoryAmount(items[4]) * 100 / helper.expense).toStringAsFixed(1)),
                            color: colors[4],
                            titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035)
                        ),
                      ]
                    )
                  )
                      : Center(child: Text("No Expense Data")),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.035),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03,
                      top: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.025,
                                  height: MediaQuery.of(context).size.width * 0.025,
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                Text(
                                  items[index],
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${helper.getCategoryAmount(items[index])}",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                                Text(
                                  "${double.parse((provider.getCategoryAmount(items[index]) * 100 / helper.expense).toStringAsFixed(1))}%",
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.033, fontWeight: FontWeight.w500, color: colors[index]),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}