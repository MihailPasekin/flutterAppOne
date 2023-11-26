import 'package:testflutterapp/models/merchproduct.dart';
import 'package:testflutterapp/models/merchproductsoldstat.dart';

class TAMerchVisit {
  int merchVisitId;
  int empId;
  String cardCode;
  String managerName;
  String managerPhone;
  String jobTitle;
  String comment;
  String merch;
  String visitDateTime;
  List<MerchProductSoldStat> productSoldStat = List.empty(growable: true);
  List<MerchProduct> itemList = List.empty(growable: true);

  TAMerchVisit(
      {required this.merchVisitId,
      required this.empId,
      required this.cardCode,
      required this.managerName,
      required this.managerPhone,
      required this.jobTitle,
      required this.comment,
      required this.merch,
      required this.visitDateTime,
      List<MerchProductSoldStat>? productSoldStat});

  factory TAMerchVisit.defaultTAMerchVisit() {
    return TAMerchVisit(
        merchVisitId: 0,
        empId: 0,
        cardCode: '',
        managerName: '',
        managerPhone: '',
        jobTitle: '',
        comment: '',
        merch: '',
        visitDateTime: '');
  }

  Map<String, dynamic> toJson() {
    return {
      "MerchVisitId": merchVisitId,
      "EmpId": empId,
      "CardCode": cardCode,
      "ManagerName": managerName,
      "ManagerPhone": managerPhone,
      "JobTitle": jobTitle,
      "Comment": comment,
      "Merch": merch,
      "VisitDateTime": visitDateTime,
      "ProductSoldStat": productSoldStat
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "MerchVisitId": merchVisitId,
      "EmpId": empId,
      "CardCode": cardCode,
      "ManagerName": managerName,
      "ManagerPhone": managerPhone,
      "JobTitle": jobTitle,
      "Comment": comment,
      "Merch": merch,
      "VisitDateTime": visitDateTime,
      "ProductSoldStat": productSoldStat
    };
  }

  factory TAMerchVisit.fromJson(Map<String, dynamic> json) {
    return TAMerchVisit(
        merchVisitId: int.parse(json['MerchVisitId'].toString()),
        empId: int.parse(json['EmpId'].toString()),
        cardCode: json['CardCode'],
        managerName: 'ManagerName',
        managerPhone: 'ManagerPhone',
        jobTitle: 'JobTitle',
        comment: 'Comment',
        merch: 'Merch',
        visitDateTime: 'VisitDateTime',
        productSoldStat: List.generate(
            json['ProductSoldStat'].length,
            (index) =>
                MerchProductSoldStat.fromJson(json['ProductSoldStat'][index])));
  }
}
