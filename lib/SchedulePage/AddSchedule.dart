import 'package:flutter/material.dart';

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
  final List<String> _types = ['outdoor', 'food', 'play', 'hospital'];

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
        title: Text('Add New Schedule'),
        backgroundColor:
            Color.fromARGB(255, 231, 218, 249), // Customize with your color
      ),
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
                  decoration: InputDecoration(
                    labelText: 'Time (HH:MM)',
                    border: OutlineInputBorder(), // Add a border
                    icon: Icon(Icons.access_time), // Add an icon
                  ),
                  keyboardType:
                      TextInputType.datetime, // Use a suitable keyboard
                  onSaved: (value) => _time = value!,
                  validator: (value) {
                    return value!.isEmpty ? 'Please enter a time' : null;
                  },
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
                    primary: Color.fromARGB(255, 231, 218, 249), // Button color
                    onPrimary: Color.fromARGB(255, 19, 19, 19), // Text color
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
