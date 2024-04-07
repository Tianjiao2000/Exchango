import 'package:flutter/material.dart';
import '../global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'StartPage.dart';

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
  void initState() {
    super.initState();
    loadPetInfo();
  }

  Future<void> loadPetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';

    if (prefs.containsKey('${email}_petType') &&
        prefs.containsKey('${email}_petName')) {
      Global.petType = prefs.getString('${email}_petType') ?? '';
      Global.petName = prefs.getString('${email}_petName') ?? '';
      _petTypeController.text = Global.petType;
      _petNameController.text = Global.petName;
    } else {
      // 这是一个新用户或者之前没有保存过信息的用户
      // 你可以设置一些默认值，或者什么也不做
      _petTypeController.text = '';
      _petNameController.text = '';
    }
  }

  Future<void> savePetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 保存宠物类型和名字
    await prefs.setString('${FirebaseAuth.instance.currentUser?.email}_petType',
        _petTypeController.text);
    await prefs.setString('${FirebaseAuth.instance.currentUser?.email}_petName',
        _petNameController.text);

    // 更新全局变量
    Global.petType = _petTypeController.text;
    Global.petName = _petNameController.text;
  }

  Future<void> clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userAvatarUrl');
    await prefs.remove('${FirebaseAuth.instance.currentUser?.email}_petType');
    await prefs.remove('${FirebaseAuth.instance.currentUser?.email}_petName');
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    await clearUserInfo(); // 清除用户信息
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartPage()),
    );
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
            onPressed: () async {
              await savePetInfo(); // 调用保存方法
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pet information saved successfully!')),
              );
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(primary: Colors.green),
          ),
          ElevatedButton(
            onPressed: () {
              _logout();
              FirebaseAuth.instance.signOut();
              // Navigator.pushReplacementNamed(context, '/StartPage');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StartPage()),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
