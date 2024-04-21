import 'package:flutter/material.dart';
import 'schedule.dart';
import 'package:intl/intl.dart';
import 'AddSchedule.dart';
import '../notification/notification_schedule.dart';
import 'package:flutter_demo/Global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Color getTypeColor(String type) {
    switch (type) {
      case 'play':
        return Colors.orange;
      case 'hospital':
        return Colors.green[800]!;
      case 'outdoor':
        return Colors.pink;
      case 'food':
        return Colors.blue[800]!;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> sortedSchedules = [];

  @override
  void initState() {
    super.initState();
    NotificationSchedule().initNotification();
    schedulePresetNotifications();
    // sortedSchedules = List.from(schedules);
    // sortedSchedules
    //     .sort((a, b) => _getTime(a['time']).compareTo(_getTime(b['time'])));
    loadSchedules();
  }

  // 加载schedules
  Future<void> loadSchedules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _auth.currentUser?.email ?? '';
    List<String> schedulesString =
        prefs.getStringList('${email}_schedules') ?? [];
    // 使用显式类型转换来分配解码后的数据
    sortedSchedules = schedulesString
        .map((s) => json.decode(s) as Map<String, dynamic>)
        .toList();
    setState(() {
      sortedSchedules
          .sort((a, b) => _getTime(a['time']).compareTo(_getTime(b['time'])));
    });
  }

  Future<void> saveSchedules() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _auth.currentUser?.email ?? '';
    // 使用字符串插值来创建键名
    List<String> schedulesString =
        sortedSchedules.map((s) => json.encode(s)).toList();
    await prefs.setStringList('${email}_schedules', schedulesString);
  }

  Future<void> schedulePresetNotifications() async {
    for (var schedule in schedules) {
      DateTime scheduleDateTime = _getDateTimeForSchedule(schedule['time']);
      // 打印调度时间和当前时间的对比，以确认通知是否应该被调度
      print(
          'Scheduling notification for: ${schedule['event']} at $scheduleDateTime');
      print('Current time is: ${DateTime.now()}');
      print(
          'Is schedule time after now? ${scheduleDateTime.isAfter(DateTime.now())}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = _auth.currentUser?.email ?? '';
      String petName = prefs.getString('${email}_petName') ?? '';

      if (scheduleDateTime.isAfter(DateTime.now())) {
        String notificationMessage =
            "It's time for ${schedule['event']} at ${schedule['location']}. ${petName} is waiting!";
        NotificationSchedule().scheduleNotification(
          schedules.indexOf(schedule), // Generate a unique ID for each schedule
          schedule['event'],
          notificationMessage,
          scheduleDateTime,
        );
      } else {
        print('Scheduled time is not after now. Not scheduling notification.');
      }
    }
  }

  DateTime _getDateTimeForSchedule(String time) {
    final format =
        DateFormat.Hm(); // Adjust the format if your input format changes
    final today = DateTime.now();
    final parsedTime = format.parse(time);
    return DateTime(
        today.year, today.month, today.day, parsedTime.hour, parsedTime.minute);
  }

  DateTime _getTime(String time) {
    final format = DateFormat.Hm();
    return format.parse(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
      ),
      backgroundColor: Color.fromARGB(255, 255, 247, 229),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 9,
          childAspectRatio: 9 / 3,
        ),
        itemCount: sortedSchedules.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> schedule = sortedSchedules[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              // Colored circle
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: getTypeColor(
                                      schedule['type'] ?? 'default'),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              // Event name
                              Expanded(
                                child: Text(
                                  schedule['event'] ?? 'Event',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          // Add space between the name and time
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 5),
                              Text(
                                schedule['time'] ?? 'Time',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16),
                              SizedBox(width: 5),
                              Text(
                                schedule['location'] ?? 'No location specified',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Button to check if event done
                    IconButton(
                      icon: Icon(
                        schedule['done']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: schedule['done'] ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          sortedSchedules[index]['done'] =
                              !sortedSchedules[index]['done'];
                        });
                      },
                    ),
                    // Delete Icon Button
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Schedule'),
                              content: Text(
                                  'Are you sure you want to delete this schedule?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    setState(() {
                                      sortedSchedules.removeAt(index);
                                    });
                                    saveSchedules();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open AddSchedule as a new page allow user add event
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSchedule()),
          );
          // If result is not null, add it to schedule list and sort
          if (result != null) {
            setState(() {
              sortedSchedules.add(result);
              sortedSchedules.sort(
                  (a, b) => _getTime(a['time']).compareTo(_getTime(b['time'])));
            });
            saveSchedules();
            DateTime scheduleDateTime = _getDateTimeForSchedule(result['time']);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String email = _auth.currentUser?.email ?? '';
            String petName = prefs.getString('${email}_petName') ?? '';
            if (scheduleDateTime.isAfter(DateTime.now())) {
              String notificationMessage =
                  "It's time for ${result['event']} at ${result['location']}. ${petName} is waiting!";
              NotificationSchedule().scheduleNotification(
                sortedSchedules.indexOf(
                    result), // Assuming this is unique enough for your case
                result['event'],
                notificationMessage,
                scheduleDateTime,
              );
            }
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Schedule',
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
      ),
    );
  }
}
