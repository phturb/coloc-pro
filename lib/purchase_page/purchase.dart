import 'package:colocpro/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'purchase.g.dart';

@JsonSerializable()
class PurchaseItem {
  String itemName;
  double itemPrice;
  User buyer;
  DateTime dateOfPurchase;
  // <username, pourcentage>
  Map<String, double> mapOfSplitPercentage = Map();
  int numberOfPersons = 0;

  PurchaseItem(this.itemName, this.itemPrice, this.buyer, this.dateOfPurchase,
      this.mapOfSplitPercentage, this.numberOfPersons);

  PurchaseItem.newItem(this.itemName, double price, this.buyer,
      this.dateOfPurchase, List<User> listOfPersons) {
    numberOfPersons = listOfPersons.length;
    final double fixPercentage = 1 / numberOfPersons;
    listOfPersons.forEach(
        (User name) => mapOfSplitPercentage[name.username] = fixPercentage);
    this.price = price;
  }

  void addPerson(User personName) {
    numberOfPersons++;
    final double fixPercentage = 1 / numberOfPersons;
    mapOfSplitPercentage.forEach((String name, double percentage) =>
        mapOfSplitPercentage[name] = fixPercentage);
    mapOfSplitPercentage[personName.username] = fixPercentage;
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  double get price => itemPrice;

  set price(double p) {
    itemPrice = p;
  }

  void resetPriceSplitPercentage() {
    final int numberOfPersons = mapOfSplitPercentage.length;
    final double fixPercentage = 1 / numberOfPersons;
    mapOfSplitPercentage.updateAll(
        (String name, double percentage) => percentage = fixPercentage);
  }
}

class PurchaseItemWidget extends StatefulWidget {
  PurchaseItemWidget(this.purchaseItem, this.editFunction);
  final Function editFunction;
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
    return InkWell(
      onDoubleTap: () => widget.editFunction(context, purchaseItem),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    child: Text(purchaseItem.buyer.username[0].toUpperCase()),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        Text(purchaseItem.itemName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(purchaseItem.itemPrice.toStringAsFixed(2) + '\$'),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                  child: Text(purchaseItem.dateOfPurchase
                      .toLocal()
                      .toString()
                      .substring(0, 10)))
            ],
          ),
        ),
      ),
    );
  }
}
