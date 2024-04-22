import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final _formKey = GlobalKey<FormState>();
  String _event = '';
  String _time = '';
  String _location = '';
  String _type = 'play'; // Default type
  final List<String> _types = ['outdoor', 'food', 'play', 'hospital', 'other'];
  final TextEditingController _timeController = TextEditingController();

  void _saveSchedule() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newSchedule = {
        'event': _event,
        'time': _time,
        'done': false,
        'type': _type,
        'location': _location,
      };
      Navigator.pop(context, newSchedule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Schedule',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
        //     Color.fromARGB(255, 231, 218, 249),
      ),
      backgroundColor: Color.fromARGB(255, 255, 247, 229),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to avoid overflow when keyboard shows
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch to fill width
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Event',
                    border: OutlineInputBorder(), // Add a border
                    icon: Icon(Icons.event), // Add an icon
                  ),
                  onSaved: (value) => _event = value!,
                  validator: (value) {
                    return value!.isEmpty ? 'Please enter an event name' : null;
                  },
                ),
                SizedBox(height: 16), // Add space between input fields
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Time (HH:MM)',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.access_time),
                  ),
                  readOnly: true, // read only
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      // use hour and minute to set time in HH:mm
                      String formattedTime =
                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                      _timeController.text =
                          formattedTime; // controller text is time selected
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time'; // check not null
                    }
                    return null;
                  },
                  onSaved: (value) => _time = value!, // save time to _state
                ),

                SizedBox(height: 16), // Add space between input fields
                DropdownButtonFormField(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(), // Add a border
                    icon: Icon(Icons.category), // Add an icon
                  ),
                  items: _types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _type = newValue!;
                    });
                  },
                  onSaved: (value) => _type = value!,
                ),
                SizedBox(height: 16), // Add space between input fields
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(), // Add a border
                    icon: Icon(Icons.location_on), // Add an icon
                  ),
                  onSaved: (value) => _location = value!,
                  validator: (value) {
                    return value!.isEmpty ? 'Please enter a location' : null;
                  },
                ),
                SizedBox(height: 24), // Add space before the button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 19, 19, 19),
                    backgroundColor:
                        Color.fromARGB(255, 255, 182, 47), // Text color
                    padding:
                        EdgeInsets.symmetric(vertical: 16), // Button padding
                  ),
                  onPressed: _saveSchedule,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
