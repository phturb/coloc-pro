// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    groupName: json['groupName'] as String,
    groupId: json['groupId'] as String,
    listOfUser: (json['listOfUser'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'listOfUser': instance.listOfUser,
    };
