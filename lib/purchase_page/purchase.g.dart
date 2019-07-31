// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) {
  return PurchaseItem(
    json['itemName'] as String,
    (json['itemPrice'] as num)?.toDouble(),
    json['buyer'] == null
        ? null
        : User.fromJson(json['buyer'] as Map<String, dynamic>),
    json['dateOfPurchase'] == null
        ? null
        : DateTime.parse(json['dateOfPurchase'] as String),
    (json['mapOfSplitPercentage'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
    json['numberOfPersons'] as int,
  )..price = (json['price'] as num)?.toDouble();
}

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'itemPrice': instance.itemPrice,
      'buyer': instance.buyer,
      'dateOfPurchase': instance.dateOfPurchase?.toIso8601String(),
      'mapOfSplitPercentage': instance.mapOfSplitPercentage,
      'numberOfPersons': instance.numberOfPersons,
      'price': instance.price,
    };
