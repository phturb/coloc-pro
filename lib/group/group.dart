import 'package:colocpro/purchase_page/purchase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'group.g.dart';

@JsonSerializable()
class Group {
  Group(
      {this.groupName,
      this.groupId,
      this.listOfPurchaseItems,
      this.mapOfDeptOfUsers,
      this.listOfUser}) {
    listOfUser ??= <String>[];
    listOfPurchaseItems ??= <PurchaseItem>[];
    groupId ??= Uuid().v1();
    if (mapOfDeptOfUsers == null) calculateDept();
  }

  String groupId;
  final String groupName;
  List<String> listOfUser;
  List<PurchaseItem> listOfPurchaseItems;
  Map<String, double> mapOfDeptOfUsers;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupName: json['groupName'] as String,
        groupId: json['groupId'] as String,
        listOfPurchaseItems: (json['listOfPurchaseItems'] as List)
            ?.map((e) => e == null
                ? null
                : PurchaseItem.fromJson(e as Map<String, dynamic>))
            ?.toList(),
        mapOfDeptOfUsers: Map<String, double>.from(json['mapOfDeptOfUsers']),
        listOfUser:
            (json['listOfUser'] as List)?.map((e) => e as String)?.toList(),
      );

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  void calculateDept() {
    mapOfDeptOfUsers = Map<String, double>();
    listOfUser.forEach((String user) => mapOfDeptOfUsers[user] = 0);
    if (listOfPurchaseItems.length > 0) {
      listOfPurchaseItems.forEach((PurchaseItem pi) {
        mapOfDeptOfUsers[pi.buyer] -=
            pi.mapOfSplitPercentage[pi.buyer] * pi.price;
        pi.mapOfSplitPercentage.forEach((String user, double percentage) {
          if (user != pi.buyer) mapOfDeptOfUsers[user] += percentage * pi.price;
        });
      });
    }
  }

  @override
  String toString() => groupId + groupName + listOfUser.toString();
}
