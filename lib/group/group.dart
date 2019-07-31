import 'package:colocpro/purchase_page/purchase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:colocpro/auth/user.dart';
import 'package:uuid/uuid.dart';
part 'group.g.dart';

@JsonSerializable()
class Group {
  Group(
      {this.groupName,
      this.mapOfMembers,
      this.groupId,
      this.listOfPurchaseItems,
      this.mapOfDeptOfUsers,
      this.listOfUser}) {
    listOfUser ??= <User>[];
    mapOfMembers ??= Map<String, User>();
    listOfUser.forEach((User user) => mapOfMembers[user.username] = user);
    listOfPurchaseItems ??= <PurchaseItem>[];
    groupId ??= Uuid().v1();
    if (mapOfDeptOfUsers == null) calculateDept();
  }

  String groupId;
  final String groupName;
  List<User> listOfUser;
  @JsonKey(ignore: true)
  Map<String, User> mapOfMembers;
  List<PurchaseItem> listOfPurchaseItems;
  @JsonKey(ignore: true)
  Map<User, double> mapOfDeptOfUsers;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  void calculateDept() {
    mapOfDeptOfUsers = Map<User, double>();
    mapOfMembers
        .forEach((String username, User user) => mapOfDeptOfUsers[user] = 0);
    if (listOfPurchaseItems.length > 0) {
      listOfPurchaseItems.forEach((PurchaseItem pi) {
        mapOfDeptOfUsers[pi.buyer] -=
            pi.mapOfSplitPercentage[pi.buyer] * pi.price;
        pi.mapOfSplitPercentage.forEach((String user, double percentage) {
          if (user != pi.buyer.username)
            mapOfDeptOfUsers[mapOfMembers[user]] += percentage * pi.price;
        });
      });
    }
  }

  @override
  String toString() => groupId + groupName + mapOfMembers.toString();
}
