import 'dart:collection';

import 'package:flutter/material.dart';

class PurchaseItem {
  double _price;
  String nameOfBuyer;
  Map<String, dynamic> mapOfSplitPersonsAmountDue = Map();
  Map<String, dynamic> mapOfSplitPercentage = Map();

  PurchaseItem({double price, this.nameOfBuyer, List<String> listOfPersons}) {
    final int numberOfPersons = listOfPersons.length;
    final double fixPercentage = 1 / numberOfPersons;
    listOfPersons
        .forEach((String name) => mapOfSplitPercentage[name] = fixPercentage);
    this.price = price;
  }

  PurchaseItem.fromJson(Map<String, dynamic> json)
      : _price = json['price'],
        nameOfBuyer = json['nameOfBuyer'],
        mapOfSplitPersonsAmountDue = json['mapOfSplitPersonsAmountDue'],
        mapOfSplitPercentage = json['mapOfSplitPercentage'];

  Map<String, dynamic> toJson() => {
        'price': _price,
        'nameOfBuyer': nameOfBuyer,
        'mapOfSplitPersonsAmountDue': mapOfSplitPersonsAmountDue,
        'mapOfSplitPercentage': mapOfSplitPercentage
      };

  static List encodeToJson(List<PurchaseItem> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  double get price => _price;
  set price(double p) {
    _price = p;
    mapOfSplitPercentage.forEach((String name, dynamic percentage) =>
        mapOfSplitPersonsAmountDue[name] = _price * percentage);
  }

  void resetPriceSplitPercentage() {
    final int numberOfPersons = mapOfSplitPercentage.length;
    final double fixPercentage = 1 / numberOfPersons;
    mapOfSplitPercentage.updateAll(
        (String name, dynamic percentage) => percentage = fixPercentage);
  }
}

class PurchaseItemWidget extends StatefulWidget {
  PurchaseItemWidget(this.purchaseItem);
  final PurchaseItem purchaseItem;
  @override
  _PurchaseItemWidgetState createState() =>
      _PurchaseItemWidgetState(purchaseItem);
}

class _PurchaseItemWidgetState extends State<PurchaseItemWidget> {
  _PurchaseItemWidgetState(this.purchaseItem);

  PurchaseItem purchaseItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: _createListOfEntry(),
        ),
      ),
    );
  }

  List<Widget> _createListOfEntry() {
    final List<Widget> listOfWidget = <Widget>[];
    listOfWidget.add(_rowCreation(purchaseItem.nameOfBuyer,
        purchaseItem.mapOfSplitPersonsAmountDue[purchaseItem.nameOfBuyer],
        isBuyer: true));
    purchaseItem.mapOfSplitPersonsAmountDue
        .forEach((String name, dynamic amount) {
      if (name != purchaseItem.nameOfBuyer)
        listOfWidget.add(_rowCreation(name, amount));
    });
    return listOfWidget;
  }

  Row _rowCreation(String name, double amount, {bool isBuyer = false}) {
    return Row(
      children: <Widget>[
        isBuyer
            ? Text(name, style: TextStyle(fontWeight: FontWeight.bold))
            : Text(name),
        Padding(
          padding: EdgeInsets.only(left: 8),
        ),
        Text(amount.toStringAsFixed(2)),
      ],
    );
  }
}
