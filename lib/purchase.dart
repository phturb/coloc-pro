import 'dart:collection';

import 'package:flutter/material.dart';

class PurchaseItem extends StatelessWidget {
  double _price;
  String _nameOfBuyer;
  Map<String, double> _mapOfSplitPersonsAmountDue = HashMap();
  Map<String, double> _mapOfSplitPercentage = HashMap();

  PurchaseItem(double price, this._nameOfBuyer, List<String> listOfPersons) {
    final int numberOfPersons = listOfPersons.length;
    final double fixPercentage = 1 / numberOfPersons;
    listOfPersons
        .forEach((String name) => _mapOfSplitPercentage[name] = fixPercentage);
    this.price = price;
  }

  String get nameOfBuyer => _nameOfBuyer;
  double get price => _price;
  set price(double p) {
    _price = p;
    _mapOfSplitPercentage.forEach((String name, double percentage) =>
        _mapOfSplitPersonsAmountDue[name] = _price * percentage);
  }

  void resetPriceSplitPercentage() {
    final int numberOfPersons = _mapOfSplitPercentage.length;
    final double fixPercentage = 1 / numberOfPersons;
    _mapOfSplitPercentage.updateAll(
        (String name, double percentage) => percentage = fixPercentage);
  }

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
    listOfWidget.add(_rowCreation(
        _nameOfBuyer, _mapOfSplitPersonsAmountDue[_nameOfBuyer],
        isBuyer: true));
    _mapOfSplitPersonsAmountDue.forEach((String name, double amount) {
      if (name != _nameOfBuyer) listOfWidget.add(_rowCreation(name, amount));
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
