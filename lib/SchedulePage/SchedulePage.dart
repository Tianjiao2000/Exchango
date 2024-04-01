import 'package:flutter/material.dart';
import 'schedule.dart';
import 'package:intl/intl.dart';
import 'AddSchedule.dart';
import '../notification/notification_schedule.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
    sortedSchedules = List.from(schedules);
    sortedSchedules
        .sort((a, b) => _getTime(a['time']).compareTo(_getTime(b['time'])));
  }

  void schedulePresetNotifications() {
    for (var schedule in schedules) {
      DateTime scheduleDateTime = _getDateTimeForSchedule(schedule['time']);
      if (scheduleDateTime.isAfter(DateTime.now())) {
        NotificationSchedule().scheduleNotification(
          // Generate a unique ID for each schedule
          schedules.indexOf(schedule),
          schedule['event'],
          "It's time for ${schedule['event']} at ${schedule['location']}",
          scheduleDateTime,
        );
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
      appBar: AppBar(title: Text('PetSync')),
      backgroundColor: Colors.grey[200],
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
            DateTime scheduleDateTime = _getDateTimeForSchedule(result['time']);
            if (scheduleDateTime.isAfter(DateTime.now())) {
              NotificationSchedule().scheduleNotification(
                sortedSchedules.indexOf(
                    result), // Assuming this is unique enough for your case
                result['event'],
                "It's time for ${result['event']} at ${result['location']}",
                scheduleDateTime,
              );
            }
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Schedule',
        // backgroundColor: Color.fromARGB(255, 222, 138, 195),
      ),
    );
  }
}
