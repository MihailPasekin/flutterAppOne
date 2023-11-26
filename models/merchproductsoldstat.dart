import 'package:testflutterapp/models/merchproduct.dart';

class MerchProductSoldStat {
  int GroupStateId;
  int MerchVisitId;
  int MerchGroupId;
  int MerchProductId;
  String MerchProdyctComment;
  String SoldStatusCod;

  MerchProductSoldStat(
      {required this.GroupStateId,
      required this.MerchVisitId,
      required this.MerchGroupId,
      required this.MerchProductId,
      required this.MerchProdyctComment,
      required this.SoldStatusCod});

  Map<String, dynamic> toJson() {
    return {
      "GroupStateId": GroupStateId,
      "MerchVisitId": MerchVisitId,
      "MerchGroupId": MerchGroupId,
      "MerchProductId": MerchProductId,
      "MerchProdyctComment": MerchProdyctComment,
      "SoldStatusCod": SoldStatusCod,
    };
  }

  factory MerchProductSoldStat.createFromMerchProduct(
      MerchProduct merchproduct) {
    return MerchProductSoldStat(
        GroupStateId: 0,
        MerchVisitId: 0,
        MerchGroupId: merchproduct.MerchProductGroupId,
        MerchProductId: merchproduct.MerchProductId,
        MerchProdyctComment: merchproduct.MerchProductComment,
        SoldStatusCod: merchproduct.checked ? "sold" : "notsold");
  }

  factory MerchProductSoldStat.fromJson(Map<String, dynamic> json) {
    return MerchProductSoldStat(
        GroupStateId: int.parse(json['GroupStateId'].toString()),
        MerchVisitId: int.parse(json['MerchVisitId'].toString()),
        MerchGroupId: int.parse(json['MerchGroupId'].toString()),
        MerchProductId: int.parse(json['MerchProductId'].toString()),
        MerchProdyctComment: json['MerchProdyctComment'],
        SoldStatusCod: json['SoldStatusCod']);
  }

  @override
  bool operator ==(Object other) =>
      other is MerchProductSoldStat &&
      MerchGroupId == other.MerchGroupId &&
      MerchProductId == other.MerchProductId;
  @override
  int get hashCode => Object.hash(MerchGroupId, MerchProductId);
}
