import 'package:testflutterapp/models/item.dart';
import 'package:testflutterapp/pages/merchandiser/merchitemgrade.dart';


class MerchSkuScore {
  int visitId;
  String itemCode;
  ItemGrade itemGrade;

  MerchSkuScore(
      {required this.visitId, required this.itemCode, required this.itemGrade});

  factory MerchSkuScore.forItemGrade(String itemCode, ItemGrade itemGrade) {
    return MerchSkuScore(visitId: 0, itemCode: itemCode, itemGrade: itemGrade);
  }

  factory MerchSkuScore.fromJson(Map<String, dynamic> json) {
    return MerchSkuScore(
        visitId: json['visitId'],
        itemCode: json['itemCode'],
        itemGrade: json['']);
  }

  Map<String, dynamic> toJson() {
    return {
      "visitId": visitId,
      "itemCode": itemCode,
    };
  }

  factory MerchSkuScore.defaultItem() {
    return MerchSkuScore(
        visitId: 0,
        itemCode: "",
        itemGrade: ItemGrade(Item.defaultItem(), false));
  }

  @override
  bool operator ==(Object other) =>
      other is MerchSkuScore &&
      itemGrade.item.ItemCode == other.itemGrade.item.ItemCode;
  @override
  int get hashCode =>
      Object.hash(itemGrade.item.ItemCode, itemGrade.item.ItemName);
}
