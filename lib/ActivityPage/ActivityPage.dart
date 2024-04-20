import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AccountPage/StartPage.dart';
import 'ButtonBlock.dart';
import 'TempBlock.dart';
import 'HumidityBlock.dart';
import 'button_info.dart';
import 'SoundBlock.dart';
import 'LightBlock.dart';

class ActivityPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userAvatarUrl');
    await prefs.remove('${_auth.currentUser?.email}_petType');
    await prefs.remove('${_auth.currentUser?.email}_petName');
  }

  void logout(BuildContext context) async {
    await _auth.signOut();
    await clearUserInfo(); // 清除用户信息
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedButtonData = List.from(buttonData)
      ..sort((a, b) => b['datetime'].compareTo(a['datetime']));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitor',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
      ),
      backgroundColor: Color.fromARGB(255, 255, 247, 229),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 10,
              child: ButtonBlock(sortedButtonData: sortedButtonData),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TempBlock(),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: HumidityBlock(),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SoundBlock(), // 声音区块
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: LightBlock(), // 光照区块
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 3,
              child: ElevatedButton(
                onPressed: () => logout(context),
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
