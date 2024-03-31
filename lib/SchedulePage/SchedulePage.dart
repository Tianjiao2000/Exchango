import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // Updated schedule items to include a 'done' status
  final List<Map<String, dynamic>> schedules = [
    {'event': 'Morning Walk', 'time': '7:00 AM', 'done': true},
    {'event': 'Feeding Time', 'time': '8:00 AM', 'done': false},
    {'event': 'Playtime', 'time': '2:00 PM', 'done': false},
  ];

  void toggleDone(int index) {
    setState(() {
      schedules[index]['done'] = !schedules[index]['done'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Adjust the number of columns
          crossAxisSpacing: 5,
          mainAxisSpacing: 9, // Adjust the padding between blocks
          childAspectRatio: 8 / 2,
        ),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15), // Add padding inside the container
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedules[index]['event']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      schedules[index]['time']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                // Icon represent if the task been done
                IconButton(
                  icon: Icon(schedules[index]['done']
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked),
                  color: schedules[index]['done'] ? Colors.green : Colors.grey,
                  onPressed: () => toggleDone(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for adding a new schedule
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Schedule',
      ),
    );
  }
}
