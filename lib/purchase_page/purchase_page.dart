import 'dart:convert';

import 'package:colocpro/purchase_page/add_purchase_page.dart';
import 'package:colocpro/purchase_page/purchase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasePage extends StatefulWidget {
  final List<Widget> listOfPurchase = <Widget>[];

  @override
  _PurchasePageState createState() => _PurchasePageState(listOfPurchase);
}

class _PurchasePageState extends State<PurchasePage> {
  _PurchasePageState(this.listOfPurchase) {
    _loadListOfPurchaseItem();
  }
  List<Widget> listOfPurchase;
  List<PurchaseItem> listOfPurchaseItem;

  void _loadListOfPurchaseItem() {
    SharedPreferences.getInstance().then((SharedPreferences sharedUser) {
      String list = sharedUser.getString("listOfPurchaseItem");
      final jsonDecode = json.decode(list);
      List<PurchaseItem> tempListPurchaseItem = <PurchaseItem>[];
      List<Widget> tempListWidget = <Widget>[];
      for (dynamic jsonItem in jsonDecode) {
        final PurchaseItem item = PurchaseItem.fromJson(jsonItem);
        tempListPurchaseItem.add(item);
        tempListWidget.add(PurchaseItemWidget(item));
      }
      setState(() {
        listOfPurchaseItem = tempListPurchaseItem;
        listOfPurchase = tempListWidget;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfPurchase == null
          ? Text('Purchase Page')
          : Column(
              children: listOfPurchase,
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_shopping_cart),
        onPressed: () => _navigateAndBringBackPurchase(context),
      ),
    );
  }

  Future<void> _navigateAndBringBackPurchase(BuildContext context) async {
    final PurchaseItem result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext buildContext) => AddPurchasePage()));
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    setState(() {
      listOfPurchaseItem.add(result);
      listOfPurchase.add(PurchaseItemWidget(result));
      sharedUser.setString(
          "listOfPurchaseItem", jsonEncode(listOfPurchaseItem));
    });
  }
}
