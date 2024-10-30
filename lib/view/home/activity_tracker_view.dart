import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/latest_activity_row.dart';
import '../../common_widget/today_target_cell.dart';

class ActivityTrackerView extends StatefulWidget {
  const ActivityTrackerView({super.key});

  @override
  State<ActivityTrackerView> createState() => _ActivityTrackerViewState();
}

class _ActivityTrackerViewState extends State<ActivityTrackerView> {
  int touchedIndex = -1;
  String selectedProgress = "Daily";

  // Variables for dynamic water intake and footsteps
  double waterIntake = 0.0; // in liters
  int footSteps = 0;

  List latestArr = [
    {
      "image": "assets/img/pic_4.png",
      "title": "Drinking 300ml Water",
      "time": "About 1 minutes ago"
    },
    {
      "image": "assets/img/pic_5.png",
      "title": "Eat Snack (Fitbar)",
      "time": "About 3 hours ago"
    },
  ];
  // Reference to Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load waterIntake and footSteps from Firestore
  Future<void> _loadUserData() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('activityTracker').doc('userId').get();

    if (snapshot.exists) {
      setState(() {
        waterIntake = snapshot['waterIntake'] ?? 0.0;
        footSteps = snapshot['footSteps'] ?? 0;
      });
    }
  }

  // Save waterIntake and footSteps to Firestore
  Future<void> _saveUserData() async {
    await _firestore.collection('activityTracker').doc('userId').set({
      'waterIntake': waterIntake,
      'footSteps': footSteps,
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Activity Tracker",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor2.withOpacity(0.3),
                    TColor.primaryColor1.withOpacity(0.3)
                  ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today Target",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.primaryG,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                onPressed: () {
                                  // Handle any button press here if needed
                                },
                                padding: EdgeInsets.zero,
                                height: 30,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                textColor: TColor.primaryColor1,
                                minWidth: double.maxFinite,
                                elevation: 0,
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Dynamic Water Intake and Footsteps Widgets
                    Row(
                      children: [
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/water.png",
                            value: "${waterIntake.toStringAsFixed(1)}L",
                            title: "Water Intake",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/foot.png",
                            value: "$footSteps",
                            title: "Foot Steps",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sliders for updating water intake and foot steps
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Adjust Water Intake (L)",
                                style: TextStyle(fontSize: 14)),
                            Text("${waterIntake.toStringAsFixed(1)}L",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Slider(
                          value: waterIntake,
                          min: 0.0,
                          max: 10.0,
                          divisions: 100,
                          label: "${waterIntake.toStringAsFixed(1)}L",
                          onChanged: (value) {
                            setState(() {
                              waterIntake = value;
                              _saveUserData(); // Save to Firestore
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Adjust Foot Steps",
                                style: TextStyle(fontSize: 14)),
                            Text("$footSteps steps",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Slider(
                          value: footSteps.toDouble(),
                          min: 0,
                          max: 20000,
                          divisions: 200,
                          label: "$footSteps",
                          onChanged: (value) {
                            setState(() {
                              footSteps = value.toInt();
                              _saveUserData(); // Save to Firestore
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activity  Progress",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedProgress,
                          items: ["Daily", "Weekly"]
                              .map((name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProgress = value!;
                            });
                          },
                          icon: Icon(Icons.expand_more, color: TColor.white),
                          hint: Text(
                            "Weekly",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.white, fontSize: 12),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              // Bar chart widget
              Container(
                height: media.width * 0.5,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ]),
                child: BarChart(BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                      tooltipMargin: 10,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String weekDay;
                        switch (group.x) {
                          case 0:
                            weekDay = 'Monday';
                            break;
                          case 1:
                            weekDay = 'Tuesday';
                            break;
                          case 2:
                            weekDay = 'Wednesday';
                            break;
                          case 3:
                            weekDay = 'Thursday';
                            break;
                          case 4:
                            weekDay = 'Friday';
                            break;
                          case 5:
                            weekDay = 'Saturday';
                            break;
                          case 6:
                            weekDay = 'Sunday';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          '$weekDay\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY - 1).toString(),
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingGroups(),
                  gridData: FlGridData(show: false),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 5.0, // Adjusted dynamically for each day
            color: touchedIndex == index ? TColor.primaryColor1 : TColor.gray,
            width: 22,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 5, 193, 14),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    switch (value.toInt()) {
      case 0:
        return Text('M', style: style);
      case 1:
        return Text('T', style: style);
      case 2:
        return Text('W', style: style);
      case 3:
        return Text('T', style: style);
      case 4:
        return Text('F', style: style);
      case 5:
        return Text('S', style: style);
      case 6:
        return Text('S', style: style);
      default:
        return Text('', style: style);
    }
  }
}
