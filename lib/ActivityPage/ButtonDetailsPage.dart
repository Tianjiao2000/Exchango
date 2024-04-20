import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonDetailsPage extends StatefulWidget {
  @override
  _ButtonDetailsPageState createState() => _ButtonDetailsPageState();
}

class _ButtonDetailsPageState extends State<ButtonDetailsPage> {
  List<PieChartSectionData> _sections = [];

  @override
  void initState() {
    super.initState();
    _loadDataAndSetupChart();
  }

  Future<void> _loadDataAndSetupChart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = FirebaseAuth.instance.currentUser?.email;
    String key = '${email}_buttonData';
    String? rawData = prefs.getString(key);

    if (rawData != null && rawData.isNotEmpty) {
      try {
        List<dynamic> decodedData = json.decode(rawData);
        Map<String, int> counts = {};
        for (var item in decodedData) {
          var name = item['name'];
          if (counts.containsKey(name)) {
            counts[name] = (counts[name])! + 1;
          } else {
            counts[name] = 1;
          }
        }

        _sections = counts.entries.map((entry) {
          return PieChartSectionData(
            color: Colors.primaries[counts.keys.toList().indexOf(entry.key) %
                Colors.primaries.length],
            value: entry.value.toDouble(),
            title: '${entry.key} (${entry.value})',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList();
        setState(() {}); // 更新界面
      } catch (e) {
        print('Error parsing button data: $e');
      }
    } else {
      print('No data found for key: $key');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Button Details',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
      ),
      backgroundColor: Color.fromARGB(255, 255, 247, 229),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _sections.isNotEmpty
              ? PieChart(
                  PieChartData(
                    sections: _sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                )
              : Text(
                  'Loading chart...',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
        ),
      ),
    );
  }
}
