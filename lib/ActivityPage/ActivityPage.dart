import 'package:flutter/material.dart';
import 'ButtonBlock.dart';
import 'TempBlock.dart';
import 'HumidityBlock.dart';
import 'button_info.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedButtonData = List.from(buttonData)
      ..sort((a, b) => b['datetime'].compareTo(a['datetime']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor'),
      ),
      backgroundColor: Colors.grey[200],
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
              flex: 5,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
