import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:http/http.dart' as http;

class MerchGroup {
  String Name;
  String Code;
  int GroupId;
  String Description;
  String GroupName;
  bool? checked;

  MerchGroup({
    required this.Name,
    required this.Code,
    required this.GroupId,
    required this.Description,
    required this.GroupName,
  });

  factory MerchGroup.fromJson(Map<String, dynamic> json) {
    return MerchGroup(
        Name: json['Name'],
        Code: json['Code'],
        GroupId: json['GroupId'],
        Description: json['Description'],
        GroupName: json['GroupName']);
  }
  Map<String, dynamic> toJson() {
    return {
      "Name": Name,
      "Code": Code,
      "GroupId": GroupId,
      "Description": Description,
      "GroupName": GroupName,
    };
  }

  factory MerchGroup.defaultDelivery() {
    return MerchGroup(
      Name: '',
      Code: '',
      GroupId: 0,
      Description: '',
      GroupName: '',
    );
  }

  static Future<List<MerchGroup>> fetchMerchGroup() async {
    final response = await http
        .get(Uri.http(await getIpAddressRoot(), '/api/Merch/getmerchgroup'));
    return compute(parseMerchGroupProps, response.body);
  }

  static List<MerchGroup> parseMerchGroupProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<MerchGroup>((propJson) => MerchGroup.fromJson(propJson))
        .toList();
  }
}
