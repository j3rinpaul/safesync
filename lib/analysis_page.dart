import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
   late List<ChartData> chartData;
   late TooltipBehavior _tooltipBehavior;
  void startCreatingDemoData() async {
    for (int i = 6; i < 13; i++) {
      if (i == 6) continue;
      await Future.delayed((Duration(seconds: 1))).then((value) {
        Random random = Random();
        flspots.add(FlSpot(
          double.parse(i.toString()),
          //double.parse(i.toString()),
          random.nextDouble(),
        ));
        setState(
          () {
            setChartData();
          },
        );
      });
    }
  }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 2:
  //       text = const Text('MAR', style: style);
  //       break;
  //     case 5:
  //       text = const Text('JUN', style: style);
  //       break;
  //     case 8:
  //       text = const Text('SEP', style: style);
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 15,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '10K';
  //       break;
  //     case 3:
  //       text = '30k';
  //       break;
  //     case 5:
  //       text = '50k';
  //       break;
  //     default:
  //       return Container();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  LineChartData data = LineChartData();
  void setChartData() {
    // final List<String> customTitles = ['accident', 'rash', 'normal'];
    // String getTitleForValue(int value) {
    //   if (value == 0) {
    //     return ''; 
    //   } else if (value < 6) {
    //     return customTitles[0];
    //   } else if (value < 11) {
    //     return customTitles[1];
    //   } else {
    //     return customTitles[2];
    //   }
    // }

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
            }),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            axisNameWidget: Center(child: Text('Time')),
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 1)),
          leftTitles: AxisTitles(
            axisNameWidget: Center(child: Text('Average speed')),
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
          )),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.black, width: 1)),
        minX: 6,
        maxX: 12,
        minY: 0,
        maxY: 150,
        lineBarsData: [
          LineChartBarData(
              spots: flspots,
              //isCurved: true,
              color: gradientColors.first,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color:
                    gradientColors.map((color) => color.withOpacity(0.3)).first,
              ))
        ]);
  }

  List<FlSpot> flspots = [const FlSpot(6, 80)];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  @override
  // void initState() {
  //   super.initState();
  //   setChartData();
  //   startCreatingDemoData();
  // }
  void initState() {
    super.initState();
    chartData = [
      ChartData(6, 80),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.y',
    );
    startCreatingDemoData();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analysis',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            
            margin: const EdgeInsets.all(50),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: LineChart(data),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average Speed=80',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  'Driving Behaviour=Rash',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}

