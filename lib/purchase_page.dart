import 'package:colocpro/add_purchase_page.dart';
import 'package:colocpro/purchase.dart';
import 'package:flutter/material.dart';

class PurchasePage extends StatefulWidget {
  final List<Widget> listOfPurchase = <Widget>[];
  @override
  _PurchasePageState createState() => _PurchasePageState(listOfPurchase);
}

class _PurchasePageState extends State<PurchasePage> {
  _PurchasePageState(this.listOfPurchase);
  List<Widget> listOfPurchase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfPurchase.isEmpty
          ? Text('Purchase Page')
          : ListView(
              children: listOfPurchase,
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_shopping_cart),
          onPressed: () => _navigateAndBringBackPurchase(context)),
    );
  }

  Future<void> _navigateAndBringBackPurchase(BuildContext context) async {
    final PurchaseItem result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext buildContext) => AddPurchasePage()));
    setState(() {
      listOfPurchase.add(result);
    });
  }
}
