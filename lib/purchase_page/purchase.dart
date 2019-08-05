import 'package:colocpro/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

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

  void resetMapOfSplitPercentage(List<User> listOfPersons) {
    mapOfSplitPercentage.clear();
    numberOfPersons = listOfPersons.length;
    final double fixPercentage = 1 / numberOfPersons;
    listOfPersons.forEach(
        (User name) => mapOfSplitPercentage[name.username] = fixPercentage);
  }

  void resetPriceSplitPercentage() {
    final int numberOfPersons = mapOfSplitPercentage.length;
    final double fixPercentage = 1 / numberOfPersons;
    mapOfSplitPercentage.updateAll(
        (String name, double percentage) => percentage = fixPercentage);
  }
}
