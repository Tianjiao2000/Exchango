import 'package:flutter/material.dart';
import '../global.dart';
import '../navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetInfoPage extends StatefulWidget {
  @override
  _PetInfoPageState createState() => _PetInfoPageState();
}

class _PetInfoPageState extends State<PetInfoPage> {
  String selectedPet = Global.petType; // 使用全局变量初始化
  final TextEditingController _customPetController = TextEditingController(
      text: Global.petType == 'custom' ? Global.petName : '');
  final TextEditingController _petNameController =
      TextEditingController(text: Global.petName);

  @override
  void initState() {
    super.initState();
    loadPetInfo();
  }

  Future<void> savePetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${Global.userEmail}_petType',
        selectedPet == 'custom' ? _customPetController.text : selectedPet);
    await prefs.setString(
        '${Global.userEmail}_petName', _petNameController.text);
  }

  Future<void> loadPetInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPet = prefs.getString('${Global.userEmail}_petType') ?? '';
      Global.petType = selectedPet;
      // 如果选中的是custom，从_customPetController读取类型
      if (selectedPet == 'custom') {
        _customPetController.text =
            prefs.getString('${Global.userEmail}_petType') ?? '';
      }
      _petNameController.text =
          prefs.getString('${Global.userEmail}_petName') ?? '';
      Global.petName = _petNameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Information'),
      ),
      body: Column(
        children: [
          Wrap(
            children: [
              for (var pet in ['dog', 'cat', 'rabbit', 'custom'])
                ChoiceChip(
                  label: Text(pet.toUpperCase()),
                  selected: selectedPet == pet,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPet = pet;
                      if (pet != 'custom') {
                        _customPetController.text = ''; // 清空自定义输入
                      }
                    });
                  },
                ),
            ],
            spacing: 8.0,
          ),
          if (selectedPet == 'custom')
            TextField(
              controller: _customPetController,
              decoration: InputDecoration(labelText: 'Custom Pet Type'),
            ),
          TextField(
            controller: _petNameController,
            decoration: InputDecoration(labelText: 'Pet Name'),
          ),
          ElevatedButton(
            onPressed: () async {
              await savePetInfo();
              Global.petType = selectedPet == 'custom'
                  ? _customPetController.text
                  : selectedPet;
              Global.petName = _petNameController.text;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigation()),
              );
            },
            child: Text('Let\'s Start'),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
