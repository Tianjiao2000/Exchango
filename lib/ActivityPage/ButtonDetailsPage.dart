import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'button_info.dart'; // 确保这个文件包含了按钮数据
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ButtonDetailsPage extends StatefulWidget {
  @override
  _ButtonDetailsPageState createState() => _ButtonDetailsPageState();
}

class _ButtonDetailsPageState extends State<ButtonDetailsPage> {
  late Map<String, int> allTimeData;
  late Map<String, int> todayData;
  late Map<String, Map<String, int>> buttonsDataByTime;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize data
    _initializeData();
  }

  Future<void> _initializeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    String storedData = prefs.getString('${email}_buttonData') ?? '[]';
    List<dynamic> jsonData = json.decode(storedData);

    DateTime now = DateTime.now();
    allTimeData = {};
    todayData = {};
    buttonsDataByTime = {};

    for (var data in jsonData) {
      String name = data['name'];
      DateTime date = DateTime.parse(data['datetime']);
      allTimeData[name] = (allTimeData[name] ?? 0) + 1;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        todayData[name] = (todayData[name] ?? 0) + 1;
      }

      String timeSlot = _getTimeSlot(date);
      buttonsDataByTime[name] ??= {
        'Morning (7am-1pm)': 0,
        'Afternoon (1pm-7pm)': 0,
        'Evening (7pm-1am)': 0,
        'Night (1am-7am)': 0
      };
      buttonsDataByTime[name]![timeSlot] =
          (buttonsDataByTime[name]![timeSlot] ?? 0) + 1;
    }

    setState(() {
      isLoading = false; // 更新加载状态
    });
  }

  String _getTimeSlot(DateTime dateTime) {
    int hour = dateTime.hour;
    if (hour >= 7 && hour < 13) {
      return 'Morning (7am-1pm)';
    } else if (hour >= 13 && hour < 19) {
      return 'Afternoon (1pm-7pm)';
    } else if (hour >= 19 || hour < 1) {
      return 'Evening (7pm-1am)';
    } else {
      return 'Night (1am-7am)';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // 在数据加载完成之前显示加载指示器
      return Scaffold(
        appBar: AppBar(
          title: Text('Button Details'),
          backgroundColor: Color.fromARGB(255, 255, 182, 47),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // 当数据加载完成后显示实际内容
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (todayData.isNotEmpty)
              _buildPieChart('Today\'s Data', todayData),
            if (allTimeData.isNotEmpty)
              _buildPieChart('All Time Data', allTimeData),
            ...buttonsDataByTime.keys
                .map((buttonName) => _buildButtonPieChart(
                    buttonName, buttonsDataByTime[buttonName]!))
                .toList(),
          ],
        ),
      ),
    );
  }
}

Widget _buildPieChart(String title, Map<String, int> data) {
  List<PieChartSectionData> sections = [];
  List<Widget> legends = [];

  int index = 0;
  data.forEach((name, value) {
    final isTouched = false;
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 50;
    final color = Colors.primaries[index % Colors.primaries.length];

    sections.add(
      PieChartSectionData(
        color: color,
        value: value.toDouble(),
        title: '$value',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      ),
    );

    legends.add(
      LegendItem(
        color: color,
        text: name,
      ),
    );

    index++;
  });

  return Card(
    elevation: 4,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 48,
                sectionsSpace: 0,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: legends,
          ),
        ],
      ),
    ),
  );
}

Widget _buildButtonPieChart(String buttonName, Map<String, int> timeData) {
  List<PieChartSectionData> sections = [];
  List<Widget> legends = [];

  Map<String, Color> timeSlotColors = {
    'Morning (7am-1pm)': Colors.blue,
    'Afternoon (1pm-7pm)': Colors.yellow,
    'Evening (7pm-1am)': Colors.orange,
    'Night (1am-7am)': Colors.purple,
  };

  timeData.forEach((timeSlot, value) {
    sections.add(
      PieChartSectionData(
        color: timeSlotColors[timeSlot]!,
        value: value.toDouble(),
        title: '$value',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      ),
    );

    legends.add(
      LegendItem(
        color: timeSlotColors[timeSlot]!,
        text: timeSlot, // 显示描述
      ),
    );
  });

  return Card(
    elevation: 4,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(buttonName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 48,
                sectionsSpace: 0,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: legends,
          ),
        ],
      ),
    ),
  );
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 18),
        SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
      ],
    );
  }
}
