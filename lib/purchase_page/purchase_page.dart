import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Widget> listOfPurchase = <Widget>[];
  List<PurchaseItem> listOfPurchaseItem = <PurchaseItem>[];

  @override
  void initState() {
    super.initState();
    _loadListOfPurchaseItem();
  }

  void _loadListOfPurchaseItem() {
    Firestore.instance
        .collection('groups')
        .document(widget.group.groupId)
        .collection('purchases')
        .getDocuments()
        .then((snapshot) {
      List<PurchaseItem> tempListPurchaseItem = <PurchaseItem>[];
      List<Widget> tempListWidget = <Widget>[];
      snapshot.documents.forEach((DocumentSnapshot ds) {
        final PurchaseItem item = PurchaseItem(
            ds.data['itemName'],
            ds.data['itemPrice'],
            ds.data['buyer'],
            DateTime.parse(ds.data['dateOfPurchase']),
            Map<String, double>.from(ds.data['mapOfSplitPercentage']),
            ds.data['numberOfPersons'],
            ds.data['purchaseID']);
        tempListPurchaseItem.add(item);
        tempListWidget.add(PurchaseItemWidget(item, _purchaseWidgetNavigate));
      });
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
    await Firestore.instance
        .collection('groups')
        .document(widget.group.groupId)
        .collection('purchases')
        .document(purchaseItem.purchaseID)
        .setData(purchaseItem.toJson());
    sharedUser.setString("listOfPurchaseItem", jsonEncode(listOfPurchaseItem));
  }

  Future<void> _navigateAndBringBackPurchase(
    BuildContext context,
  ) async {
    final PurchaseItem result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext buildContext) => AddPurchasePage(
          widget.group,
        ),
      ),
    );
    if (result != null) {
      await Firestore.instance
          .collection('groups')
          .document(widget.group.groupId)
          .collection('purchases')
          .document(result.purchaseID)
          .setData(result.toJson());

      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      setState(() {
        widget.group.listOfPurchaseItems = listOfPurchaseItem;
        listOfPurchaseItem.add(result);
        listOfPurchase.add(PurchaseItemWidget(result, _purchaseWidgetNavigate));
      });
      sharedUser.setString(
          "listOfPurchaseItem", jsonEncode(listOfPurchaseItem));
    }
  }
}
