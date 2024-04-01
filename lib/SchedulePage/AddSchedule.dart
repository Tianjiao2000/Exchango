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
      appBar: AppBar(title: Text('Add New Schedule')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Event'),
                onSaved: (value) => _event = value!,
                validator: (value) {
                  return value!.isEmpty ? 'Please enter an event name' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time (HH:MM)'),
                onSaved: (value) => _time = value!,
                validator: (value) {
                  return value!.isEmpty ? 'Please enter a time' : null;
                },
              ),
              DropdownButtonFormField(
                value: _type,
                decoration: InputDecoration(labelText: 'Type'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => _location = value!,
                validator: (value) {
                  return value!.isEmpty ? 'Please enter a location' : null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _saveSchedule,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
