import 'package:testflutterapp/models/merchgroupscore.dart';
import 'package:testflutterapp/models/merchskuscore.dart';

class CustomMerch {
  String Name;
  String Code;
  int VisitId;
  int EmpID;
  String Created;
  String CardCode;
  String Comment;
  List<MerchSkuScore> SkuScoreList = List.empty(growable: true);

  List<MerchGroupScore> GroupScoreList = List.empty(growable: true);

  CustomMerch({
    required this.Name,
    required this.Code,
    required this.VisitId,
    required this.EmpID,
    required this.Created,
    required this.CardCode,
    required this.Comment,
  });

  factory CustomMerch.defaultCustomerMerch() {
    return CustomMerch(
        Name: "",
        Code: "0",
        VisitId: 0,
        EmpID: 0,
        Created: "",
        CardCode: "",
        Comment: "");
  }
  Map<String, dynamic> toJson() {
    return {
      "Name": Name,
      "Code": Code,
      "VisitId": VisitId,
      "EmpID": EmpID,
      "Created": Created,
      "CardCode": CardCode,
      "Comment": Comment,
      "SkuScoreList": SkuScoreList,
      "GroupScoreList": GroupScoreList
    };
  }
}
