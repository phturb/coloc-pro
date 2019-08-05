import 'package:colocpro/purchase_page/purchase.dart';
import 'package:flutter/material.dart';

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
