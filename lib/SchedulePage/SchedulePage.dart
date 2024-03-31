import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: SchedulePage()));

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, dynamic>> schedules = [
    {
      'event': 'Morning Walk',
      'time': '7:00 AM',
      'done': true,
      'type': 'outdoor',
      'location': 'Park'
    },
    {
      'event': 'Feeding Time',
      'time': '8:00 AM',
      'done': false,
      'type': 'food',
      'location': 'Kitchen'
    },
    {
      'event': 'Playtime',
      'time': '2:00 PM',
      'done': false,
      'type': 'play',
      'location': 'Living Room'
    },
  ];

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
        return Colors.grey; // Default color if type not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PetSync')),
      backgroundColor:
          Colors.grey[200], // Set the background color to light grey
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 9,
          childAspectRatio: 8 / 3,
        ),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> schedule = schedules[index];
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white, // Block background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Colored circle representing the event type
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: getTypeColor(schedule['type'] ?? 'default'),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      schedule['event'] ?? 'Event',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(schedule['done']
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked),
                    color: schedule['done'] ? Colors.green : Colors.grey,
                    onPressed: () =>
                        setState(() => schedule['done'] = !schedule['done']),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          tooltip: 'Add New Schedule'),
    );
  }
}
