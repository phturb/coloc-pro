import 'package:json_annotation/json_annotation.dart';
import 'package:colocpro/auth/user.dart';
part 'group.g.dart';

@JsonSerializable()
class Group {
  Group({this.groupName, this.listOfMembers, this.groupId = '1'});

  String groupId;
  final String groupName;
  Set<User> listOfMembers;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  String toString() => groupId + groupName + listOfMembers.toString();
}
