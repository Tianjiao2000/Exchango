import 'package:flutter/material.dart';

class CurrencyPage extends StatelessWidget {
  CurrencyPage({Key? key}) : super(key: key);

  // Controllers to manage text input for currency pairs and amount
  final TextEditingController _currencyController1 = TextEditingController();
  final TextEditingController _currencyController2 = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 80.0, 25.0, 25.0),
        child: Row(
          children: <Widget>[
            // First currency input
            Expanded(
              child: TextField(
                controller: _currencyController1,
                decoration: InputDecoration(
                  labelText: 'Currency 1',
                  hintText: 'USD',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8), // Horizontal spacing
            // Amount input
            Expanded(
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: '1000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Numeric keyboard
              ),
            ),
            SizedBox(width: 8), // Horizontal spacing
            // Second currency input
            Expanded(
              child: TextField(
                controller: _currencyController2,
                decoration: InputDecoration(
                  labelText: 'Currency 2',
                  hintText: 'EUR',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Search button
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Perform search or other action using the input values
                // Here we navigate to the NewPage passing the values from the input fields
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPage(
                      currency1: _currencyController1.text,
                      currency2: _currencyController2.text,
                      amount: _amountController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  final String currency1;
  final String currency2;
  final String amount;

  // Constructor receives two currencies and the amount
  const NewPage(
      {Key? key,
      required this.currency1,
      required this.currency2,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion Results'),
      ),
      body: Center(
        // Display the values passed to the page
        child: Text('From: $currency1\nTo: $currency2\nAmount: $amount'),
      ),
    );
  }
}
