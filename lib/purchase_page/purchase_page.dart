import 'dart:convert';

import 'package:colocpro/group/group.dart';
import 'package:colocpro/purchase_page/add_purchase_page.dart';
import 'package:colocpro/purchase_page/purchase.dart';
import 'package:colocpro/purchase_page/purchase_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasePage extends StatefulWidget {
  PurchasePage(this.group);
  final Group group;
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  _PurchasePageState() {
    _loadListOfPurchaseItem();
  }
  List<Widget> listOfPurchase = <Widget>[];
  List<PurchaseItem> listOfPurchaseItem = <PurchaseItem>[];

  void _loadListOfPurchaseItem() {
    SharedPreferences.getInstance().then((SharedPreferences sharedUser) {
      String list = sharedUser.getString("listOfPurchaseItem");
      List<PurchaseItem> tempListPurchaseItem = <PurchaseItem>[];
      List<Widget> tempListWidget = <Widget>[];
      if (list == null) return;
      final j = jsonDecode(list);
      for (dynamic jsonItem in j) {
        final PurchaseItem item = PurchaseItem.fromJson(jsonItem);
        tempListPurchaseItem.add(item);
        tempListWidget.add(PurchaseItemWidget(item, _purchaseWidgetNavigate));
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

  Future<void> _purchaseWidgetNavigate(
      BuildContext context, PurchaseItem purchaseItem) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext buildContext) => AddPurchasePage(
              widget.group,
              purchaseItem: purchaseItem,
            )));
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    setState(() {});
    sharedUser.setString("listOfPurchaseItem", jsonEncode(listOfPurchaseItem));
  }

  Future<void> _navigateAndBringBackPurchase(
    BuildContext context,
  ) async {
    final dynamic result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext buildContext) => AddPurchasePage(
              widget.group,
            )));
    if (result != null) {
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      setState(() {
        listOfPurchaseItem.add(result);
        listOfPurchase.add(PurchaseItemWidget(result, _purchaseWidgetNavigate));
      });
      sharedUser.setString(
          "listOfPurchaseItem", jsonEncode(listOfPurchaseItem));
    }
  }
}
