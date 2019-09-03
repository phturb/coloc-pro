// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    name: json['name'] as String,
    familyName: json['familyName'] as String,
    currentGroup: json['currentGroup'] as String,
    mapOfGroup: (json['mapOfGroup'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'familyName': instance.familyName,
      'currentGroup': instance.currentGroup,
      'mapOfGroup': instance.mapOfGroup,
    };
