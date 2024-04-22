import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:safe/phonenumbers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<FlSpot> flspots;
  late LineChartData data;

  @override
  void initState() {
    super.initState();
    flspots = [FlSpot(6, 0)];
    data = LineChartData();
    startCreatingDemoData();
    setChartData();
  }

  void startCreatingDemoData() async {
    for (int i = 6; i < 13; i++) {
      if (i == 6) continue;
      await Future.delayed((Duration(seconds: 1))).then((value) {
        Random random = Random();
        flspots.add(FlSpot(
          double.parse(i.toString()),
          random.nextDouble(),
        ));
        setState(() {
          setChartData();
        });
      });
    }
  }

  void setChartData() {
    data = LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          axisNameWidget: Center(child: Text('Time')),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Center(child: Text('Average speed')),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.black, width: 1),
      ),
      minX: 6,
      maxX: 12,
      minY: 0,
      maxY: 15,
      lineBarsData: [
        LineChartBarData(
          spots: flspots,
          isCurved: true,
          color: gradientColors.first,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: gradientColors
                .map((color) => color.withOpacity(0.3))
                .first,
          ),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                //height:MediaQuery.of(context).size.width * 0.2 ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(
                      child: Text(
                        'Name: John Doe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Age: 30',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
           DataListWidget(),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: 0.7,
                  center: Text(
                    "70.0%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  footer: const Text(
                    "Average Speed\n of the Month",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 17.0,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.purple,
                ),
                 CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: 0.7,
                  center: Text(
                    "70.0%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  footer: const Text(
                    "Average Driving Behaviour\n of the Month",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 17.0,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.purple,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(45),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: LineChart(data),
            ),
            
          ],
        ),
      ),
    );
  }
}
