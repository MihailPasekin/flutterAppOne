import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:testflutterapp/models/connstring.dart';
import 'package:http/http.dart' as http;

class MerchProduct {
  int MerchProductId;
  int MerchProductGroupId;
  String MerchProductName;
  String MerchProductComment = '';
  bool checked = false;

  MerchProduct(
      {required this.MerchProductId,
      required this.MerchProductGroupId,
      required this.MerchProductName});

  factory MerchProduct.fromJson(Map<String, dynamic> json) {
    return MerchProduct(
      MerchProductId: json['MerchProductId'],
      MerchProductGroupId: json['MerchProductGroupId'],
      MerchProductName: json['MerchProductName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MerchProductId": MerchProductId,
      "MerchProductGroupId": MerchProductGroupId,
      "MerchProductName": MerchProductName,
    };
  }

  factory MerchProduct.defaultMerchProduct() {
    return MerchProduct(
      MerchProductId: 0,
      MerchProductGroupId: 0,
      MerchProductName: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MerchProduct && MerchProductId == other.MerchProductId;
  @override
  int get hashCode => Object.hash(MerchProductId, MerchProductName);

  static Future<List<MerchProduct>> fetchMerchProduct() async {
    final response = await http
        .get(Uri.http(await getIpAddressRoot(), '/api/Merch/getmerchproduct'));
    return compute(parseMerchGroupProps, response.body);
  }

  static List<MerchProduct> parseMerchGroupProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<MerchProduct>((propJson) => MerchProduct.fromJson(propJson))
        .toList();
  }
}
