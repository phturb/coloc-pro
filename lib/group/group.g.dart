// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    groupName: json['groupName'] as String,
    groupId: json['groupId'] as String,
    listOfPurchaseItems: (json['listOfPurchaseItems'] as List)
        ?.map((e) =>
            e == null ? null : PurchaseItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    listOfUser: (json['listOfUser'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'listOfUser': instance.listOfUser,
      'listOfPurchaseItems': instance.listOfPurchaseItems,
    };
