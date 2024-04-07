import 'package:flutter/material.dart';
import '../global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _petTypeController =
      TextEditingController(text: Global.petType);
  final TextEditingController _petNameController =
      TextEditingController(text: Global.petName);

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        Global.userAvatarUrl = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: Global.userAvatarUrl.isNotEmpty
                  ? FileImage(File(Global.userAvatarUrl))
                  : null,
              child: Icon(Icons.camera_alt),
            ),
          ),
          Text('Email: ${Global.userEmail}'),
          TextField(
            controller: _petTypeController,
            decoration: InputDecoration(labelText: 'Pet Type'),
            onChanged: (value) => Global.petType = value,
          ),
          TextField(
            controller: _petNameController,
            decoration: InputDecoration(labelText: 'Pet Name'),
            onChanged: (value) => Global.petName = value,
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/loginPage');
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
