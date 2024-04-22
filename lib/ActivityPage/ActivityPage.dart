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
  // firebase and text update parameter
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

  // save to local
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

// logout clear user info
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
    double screenHeight = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> sortedButtonData = List.from(buttonData)
      ..sort((a, b) => b['datetime'].compareTo(a['datetime']));

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: !_isEditing
                        ? Text("My Name: ${_petNameController.text}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04))
                        : TextField(
                            controller: _petNameController,
                            decoration: InputDecoration(
                              labelText: 'Edit Pet Name',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1.0),
                              ),
                            ),
                          ),
                  ),
                  IconButton(icon: Icon(Icons.edit), onPressed: toggleEdit),
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
              SizedBox(height: screenHeight * 0.005),
              Container(
                height: screenHeight * 0.4,
                child: ButtonBlock(sortedButtonData: sortedButtonData),
              ),
              SizedBox(height: screenHeight * 0.025),
              Container(
                height: screenHeight * 0.125,
                child: Row(
                  children: <Widget>[
                    Expanded(child: TempBlock()),
                    SizedBox(width: 15),
                    Expanded(child: HumidityBlock()),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Container(
                height: screenHeight * 0.125,
                child: Row(
                  children: <Widget>[
                    Expanded(child: SoundBlock()),
                    SizedBox(width: 15),
                    Expanded(child: LightBlock()),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              ElevatedButton(
                onPressed: () => logout(context),
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
