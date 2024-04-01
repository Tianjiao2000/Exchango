import 'package:flutter/material.dart';
import 'button_info.dart';
import 'package:intl/intl.dart';
import 'ButtonDetailsPage.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedButtonData = List.from(buttonData)
      ..sort((a, b) => b['datetime'].compareTo(a['datetime']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor'),
      ),
      backgroundColor: Colors.grey[200], // Set the background color of the page
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 10, // Allocate a flex factor for the button-related content
              child: Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // full width of the screen
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Header row with "Buttons" and eye icon
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Buttons',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              // Navigate to ButtonDetailsPage when the eye icon is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ButtonDetailsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Scrollable list of buttons
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedButtonData.length,
                        itemBuilder: (context, index) {
                          var buttonInfo = sortedButtonData[index];
                          return ListTile(
                            title: Text(buttonInfo['name']),
                            subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm')
                                .format(buttonInfo['datetime'])),
                            trailing: Icon(Icons.arrow_forward),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1, // Allocate a flex factor for spacing
              child: Container(), // This will just be empty space
            ),
            Flexible(
              flex:
                  3, // Allocate a flex factor for the bottom blocks (2 for each)
              child: Row(
                // This row contains the temperature and humidity blocks
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // This container is for the temperature
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text('Temp')),
                    ),
                  ),
                  SizedBox(
                      width:
                          15), // Provides spacing between the temp and humidity blocks
                  Expanded(
                    child: Container(
                      // This container is for the humidity
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text('Humidity')),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5, // Allocate a flex factor for spacing
              child: Container(), // This will just be empty space
            ),
          ],
        ),
      ),
    );
  }
}
