import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:testflutterapp/models/planedetailmerch.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:http/http.dart' as http;

class PlanMerch {
  int PlanId;
  int EmpId;
  DateTime PlanDate;
  DateTime CreatedAt;
  DateTime? UpdatedAt;
  String? PlanStatus;
  String? Coment;
  int? CreatedUserId;
  List<PlanDetail>? PlanDetails;

  PlanMerch({
    required this.PlanId,
    required this.EmpId,
    required this.PlanDate,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.PlanStatus,
    required this.Coment,
    required this.CreatedUserId,
    this.PlanDetails,
  });

  factory PlanMerch.defaultPlanMerch() {
    return PlanMerch(
        PlanId: 0,
        EmpId: 0,
        PlanDate: DateTime.now(),
        CreatedAt: DateTime.now(),
        UpdatedAt: DateTime.now(),
        PlanStatus: '',
        Coment: '',
        CreatedUserId: 0,
        PlanDetails: List.empty(growable: true));
  }

  Map<String, dynamic> toMap() {
    return {
      "PlanId": PlanId,
      "EmpId": EmpId,
      "PlanDate": PlanDate.toString(),
      "CreatedAt": CreatedAt.toString(),
      "UpdatedAt": UpdatedAt.toString(),
      "PlanStatus": PlanStatus,
      "Coment": Coment,
      "CreatedUserId": CreatedUserId,
    };
  }

  factory PlanMerch.fromJson(Map<String, dynamic> json) {
    return PlanMerch(
        PlanId: json['PlanId'],
        EmpId: json['EmpId'],
        PlanDate: DateTime.parse(json['PlanDate']),
        CreatedAt: DateTime.parse(json['CreatedAt']),
        UpdatedAt: DateTime.parse(json['UpdatedAt']),
        PlanStatus: json['PlanStatus'],
        Coment: json['Coment'],
        CreatedUserId: json['CreatedUserId'],
        PlanDetails: List.generate(json["PlanDetails"].length,
            (index) => PlanDetail.fromJson(json['PlanDetails'][index])));
  }
  factory PlanMerch.fromJsonDb(Map<String, dynamic> json) {
    return PlanMerch(
      PlanId: json['PlanId'],
      EmpId: json['EmpId'],
      PlanDate: DateTime.parse(json['PlanDate']),
      CreatedAt: DateTime.parse(json['CreatedAt']),
      UpdatedAt: DateTime.parse(json['UpdatedAt']),
      PlanStatus: json['PlanStatus'],
      Coment: json['Coment'],
      CreatedUserId: json['CreatedUserId'],
    );
  }
  static Future<List<PlanMerch>> fetchPlanMerch(empId) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),
        '/api/MerchPlan/getemploemerchplans', {'empId': empId.toString()}));

    return compute(parseProps, response.body);
  }

  static List<PlanMerch> parseProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<PlanMerch>((propJson) => PlanMerch.fromJson(propJson))
        .toList();
  }
}
