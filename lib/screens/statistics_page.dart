import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../utils/app_colors.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DatabaseReference _databaseReference;
  List<FlSpot> _heartRateData = [];
  List<FlSpot> _tempData = [];
  List<FlSpot> _bpDData = [];
  List<FlSpot> _bpNData = [];

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref('ESP');
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _heartRateData.add(FlSpot(_heartRateData.length.toDouble(), double.parse(data['Heart_rate'].toString())));
        _tempData.add(FlSpot(_tempData.length.toDouble(), double.parse(data['Temperature'].toString())));
        _bpDData.add(FlSpot(_bpDData.length.toDouble(), double.parse(data['bp_d'].toString())));
        _bpNData.add(FlSpot(_bpNData.length.toDouble(), double.parse(data['bp_n'].toString())));
      });
    });
  }

  Widget _buildGraph(String title, List<FlSpot> data, Color color, double maxY) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(
          height: 400,
          child: LineChart(
            LineChartData(
              maxY: maxY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  color: color,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Real-Time ",
              style: TextStyle(
                  color: AppColors.primaryColor1,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Statistics",
              style: TextStyle(
                  color: AppColors.primaryColor2,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildGraph("Heart Rate", _heartRateData, AppColors.primaryColor1, 110.0),
              SizedBox(height: 20),
              _buildGraph("Temperature (C)", _tempData, AppColors.primaryColor2, 37.0),
              SizedBox(height: 20),
              _buildGraph("Blood Pressure (Diastolic)", _bpDData, AppColors.secondaryColor1, 100),
              SizedBox(height: 20),
              _buildGraph("Blood Pressure (Systolic)", _bpNData, AppColors.primaryColor1, 140),
            ],
          ),
        ),
      ),
    );
  }
}
