import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../StartPage.dart';
import 'ButtonBlock.dart';
import 'TempBlock.dart';
import 'HumidityBlock.dart';
import 'button_info.dart';
import 'SoundBlock.dart';
import 'LightBlock.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _petNameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    loadPetInfo();
  }

  Future<void> loadPetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _auth.currentUser?.email ?? '';
    String loadedPetName = prefs.getString('${email}_petName') ?? '';
    // use setstate to update ui
    setState(() {
      _petNameController.text = loadedPetName;
    });
  }

  Future<void> savePetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${_auth.currentUser?.email}_petName', _petNameController.text);
    setState(() {
      _isEditing = false;
    });
  }

  void toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userAvatarUrl');
    await prefs.remove('${_auth.currentUser?.email}_petType');
    await prefs.remove('${_auth.currentUser?.email}_petName');
  }

  void logout(BuildContext context) async {
    await _auth.signOut();
    // clear user info when logout
    await clearUserInfo();
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
          textAlign: TextAlign.center,
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
            Row(
              children: [
                Expanded(
                  child: !_isEditing
                      ? Text("My Name: ${_petNameController.text}")
                      : TextField(
                          controller: _petNameController,
                          decoration: InputDecoration(
                            labelText: 'Edit Pet Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: toggleEdit,
                ),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: savePetInfo,
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
              ],
            ),
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
                    child: SoundBlock(),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: LightBlock(),
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
