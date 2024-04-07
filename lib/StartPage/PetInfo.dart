import 'package:flutter/material.dart';
import '../global.dart'; // 引入刚刚创建的全局变量文件
import '../navigation.dart';

class PetInfoPage extends StatefulWidget {
  @override
  _PetInfoPageState createState() => _PetInfoPageState();
}

class _PetInfoPageState extends State<PetInfoPage> {
  String selectedPet = 'dog'; // 默认选择
  final TextEditingController _customPetController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();

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
            onPressed: () {
              // 保存宠物类型和名字
              Global.petType = selectedPet == 'custom'
                  ? _customPetController.text
                  : selectedPet;
              Global.petName = _petNameController.text;

              // 进入主页面（此处需要替换为你的主页面路由）
              // Navigator.pushReplacementNamed(context, '/mainPage');
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
