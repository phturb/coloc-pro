import 'package:colocpro/auth/user.dart';
import 'package:colocpro/group/group.dart';
import 'package:flutter/material.dart';
import 'package:colocpro/purchase_page/purchase.dart';
import 'package:flutter/services.dart';

class AddPurchasePage extends StatefulWidget {
  AddPurchasePage(this.group, {this.purchaseItem});

  final Group group;
  final PurchaseItem purchaseItem;
  @override
  AddPurchasePageState createState() => AddPurchasePageState();
}

class AddPurchasePageState extends State<AddPurchasePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Map<String, bool> mapOfInvolveUser = Map<String, bool>();
  List<CheckboxListTile> listOfCheckboxListTile = <CheckboxListTile>[];
  List<DropdownMenuItem<User>> dropDownMenuItems;
  User currentBuyer;
  double currentPrice = 0;

  void populateMapOfInvolveUser(User user) {
    bool tempVal = false;
    mapOfInvolveUser[user.username] = tempVal;
  }

  @override
  void initState() {
    super.initState();
    if (widget.purchaseItem == null) {
      widget.group.listOfUser.forEach(populateMapOfInvolveUser);
      amountController.text = currentPrice.toStringAsFixed(2);
    } else {
      widget.group.listOfUser.forEach((User user) {
        if (widget.purchaseItem.mapOfSplitPercentage[user.username] != null)
          mapOfInvolveUser[user.username] =
              widget.purchaseItem.mapOfSplitPercentage[user.username] != 0;
      });
      amountController.text = widget.purchaseItem.price.toStringAsFixed(2);
      nameController.text = widget.purchaseItem.itemName;
    }
    listOfCheckboxListTile = _getCheckBoxList();
    dropDownMenuItems = getDropDownMenuItems();
    currentBuyer = dropDownMenuItems[0].value;
  }

  List<DropdownMenuItem<User>> getDropDownMenuItems() {
    List<DropdownMenuItem<User>> items = <DropdownMenuItem<User>>[];
    for (User user in widget.group.listOfUser) {
      items.add(DropdownMenuItem(
        value: user,
        child: Text(user.username),
      ));
    }
    return items;
  }

  List<CheckboxListTile> _getCheckBoxList() {
    return mapOfInvolveUser.keys.map((String key) {
      return CheckboxListTile(
        title: Text(key),
        subtitle:
            Text((currentPrice / mapOfInvolveUser.length).toStringAsFixed(2)),
        value: mapOfInvolveUser[key],
        onChanged: (bool value) {
          setState(() {
            mapOfInvolveUser[key] = value;
          });
        },
        secondary: CircleAvatar(
          child: Text(key[0].toUpperCase()),
        ),
      );
    }).toList();
  }

  void returnSaveButton(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    listOfCheckboxListTile = _getCheckBoxList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase page'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration:
                  InputDecoration(labelText: 'Enter the name of the item'),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Flexible(
                child: TextField(
                  controller: amountController,
                  onSubmitted: (String string) => setState(() {
                    amountController.text = string.isEmpty ? '0.00' : string;
                    if (string.isEmpty) currentPrice = 0;
                  }),
                  onChanged: updateAmountSplit,
                  decoration: InputDecoration(labelText: 'Enter the amount'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Flexible(
                child: _buildDateTimePicker(context),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Buyer :'),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButton(
                  value: currentBuyer,
                  items: dropDownMenuItems,
                  onChanged: (User user) => setState(() {
                    currentBuyer = user;
                  }),
                ),
              ],
            ),
            Container(
              height: 300,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: listOfCheckboxListTile.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return listOfCheckboxListTile[index];
                  },
                ),
              ),
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

  void updateAmountSplit(String amountString) {
    if (amountString.isEmpty)
      currentPrice = 0;
    else
      currentPrice = double.parse(amountString);
    setState(() {
      listOfCheckboxListTile = _getCheckBoxList();
    });
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of the purchase',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${selectedDate.toLocal().toString().substring(0, 10)}"),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _acceptInput() {
    if (widget.purchaseItem == null) {
      Navigator.pop(
        context,
        PurchaseItem.newItem(
          nameController.text,
          currentPrice,
          currentBuyer,
          selectedDate,
          widget.group.listOfUser,
        ),
      );
    } else {
      widget.purchaseItem.itemName = nameController.text;
      widget.purchaseItem.price = currentPrice;
      widget.purchaseItem.buyer = currentBuyer;
      widget.purchaseItem.dateOfPurchase = selectedDate;
      Navigator.pop(context);
    }
  }
}
