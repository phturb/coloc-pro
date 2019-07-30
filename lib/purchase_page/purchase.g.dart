// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) {
  return PurchaseItem(
    (json['itemPrice'] as num)?.toDouble(),
    json['nameOfBuyer'] as String,
    (json['mapOfSplitPercentage'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
    (json['mapOfSplitPersonsAmountDue'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
  )..price = (json['price'] as num)?.toDouble();
}

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) =>
    <String, dynamic>{
      'itemPrice': instance.itemPrice,
      'nameOfBuyer': instance.nameOfBuyer,
      'mapOfSplitPersonsAmountDue': instance.mapOfSplitPersonsAmountDue,
      'mapOfSplitPercentage': instance.mapOfSplitPercentage,
      'price': instance.price,
    };
