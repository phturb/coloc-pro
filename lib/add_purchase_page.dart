import 'package:flutter/material.dart';
import 'purchase.dart';

class AddPurchasePage extends StatefulWidget {
  @override
  AddPurchasePageState createState() => AddPurchasePageState();
}

class AddPurchasePageState extends State<AddPurchasePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void returnSaveButton(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase page'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
        child: Column(
          children: <Widget>[
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Enter the amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _acceptInput,
        child: Icon(Icons.save_alt),
      ),
    );
  }

  void _acceptInput() {
    Navigator.pop(
        context,
        PurchaseItem(
            double.parse(amountController.text),
            nameController.text,
            <String>['Phil', 'Steph', 'Johny'] +
                <String>[nameController.text]));
  }
}
