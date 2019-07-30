import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'purchase.g.dart';

@JsonSerializable()
class PurchaseItem {
  double itemPrice;
  String nameOfBuyer;
  Map<String, double> mapOfSplitPersonsAmountDue = Map();
  Map<String, double> mapOfSplitPercentage = Map();

  PurchaseItem(this.itemPrice, this.nameOfBuyer, this.mapOfSplitPercentage,
      this.mapOfSplitPersonsAmountDue);

  PurchaseItem.newItem(
      {double price, this.nameOfBuyer, List<String> listOfPersons}) {
    final int numberOfPersons = listOfPersons.length;
    final double fixPercentage = 1 / numberOfPersons;
    listOfPersons
        .forEach((String name) => mapOfSplitPercentage[name] = fixPercentage);
    this.price = price;
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  double get price => itemPrice;
  set price(double p) {
    itemPrice = p;
    mapOfSplitPercentage.forEach((String name, double percentage) =>
        mapOfSplitPersonsAmountDue[name] = itemPrice * percentage);
  }

  void resetPriceSplitPercentage() {
    final int numberOfPersons = mapOfSplitPercentage.length;
    final double fixPercentage = 1 / numberOfPersons;
    mapOfSplitPercentage.updateAll(
        (String name, double percentage) => percentage = fixPercentage);
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
