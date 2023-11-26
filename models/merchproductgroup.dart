import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testflutterapp/models/connstring.dart';

class MerchProductGroup {
  int merchGroupId;
  String merchGroupName;
  String description;
  String cod;
  bool checked = false;

  MerchProductGroup(
      {required this.merchGroupId,
      required this.merchGroupName,
      required this.description,
      required this.cod});

  factory MerchProductGroup.fromJson(Map<String, dynamic> json) {
    return MerchProductGroup(
      merchGroupId: json['MerchGroupId'],
      merchGroupName: json['GroupName'],
      description: json['Description'],
      cod: json['Cod'],
    );
  }
  factory MerchProductGroup.fromJsonDB(Map<String, dynamic> json) {
    return MerchProductGroup(
      merchGroupId: json['MerchGroupId'],
      merchGroupName: json['MerchGroupName'],
      description: json['Description'],
      cod: json['Cod'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "merchGroupId": merchGroupId,
      "merchGroupName": merchGroupName,
      "description": description,
      "cod": cod,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "merchGroupId": merchGroupId,
      "merchGroupName": merchGroupName,
      "description": description,
      "cod": cod,
    };
  }

  factory MerchProductGroup.defaultDelivery() {
    return MerchProductGroup(
      merchGroupId: 0,
      merchGroupName: '',
      description: '',
      cod: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MerchProductGroup && merchGroupId == other.merchGroupId;
  @override
  int get hashCode => Object.hash(merchGroupId, merchGroupName);

  static Future<List<MerchProductGroup>> fetchMerchProductGroup() async {
    final response = await http.get(
        Uri.http(await getIpAddressRoot(), '/api/Merch/getmerchproductgroup'));
    return compute(parseMerchGroupProps, response.body);
  }

  static List<MerchProductGroup> parseMerchGroupProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<MerchProductGroup>(
            (propJson) => MerchProductGroup.fromJson(propJson))
        .toList();
  }

  static MerchProductGroup defaultCustomer() {
    return MerchProductGroup(
        merchGroupId: 0, merchGroupName: '', description: '', cod: '');
  }
}
