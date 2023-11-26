import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:testflutterapp/dbworker.dart';

import 'connstring.dart';

class Order {
  int? id;
  final int docEntry;
  final int docNum;
  final String docStatus;
  final DateTime docDate;
  final String cardCode;
  final String cardName;
  final double docTotal;
  final double grosProfit;
  final int ownerCode;
  final int groupNum;
  final String payType;

  Order(
      {this.id,
      required this.docEntry,
      required this.docNum,
      required this.docStatus,
      required this.docDate,
      required this.cardCode,
      required this.cardName,
      required this.docTotal,
      required this.grosProfit,
      required this.ownerCode,
      required this.groupNum,
      required this.payType});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        docEntry: json['DocEntry'],
        docNum: json['DocNum'],
        docStatus: json['DocStatus'],
        docDate: DateTime.parse(json['DocDate']),
        cardCode: json['CardCode'],
        cardName: json['CardName'],
        docTotal: double.parse(json['DocTotal'].toString()),
        grosProfit: double.parse(json['GrosProfit'].toString()),
        ownerCode: json['OwnerCode'],
        groupNum: int.parse(json['GroupNum'].toString()),
        payType: json['PayType']);
  }

  factory Order.fromJsonDatabase(Map<String, dynamic> json) {
    return Order(
        id: int.parse(json['id'].toString()),
        docEntry: json['docEntry'],
        docNum: json['docNum'],
        docStatus: json['docStatus'],
        docDate: DateTime.parse(json['docDate']),
        cardCode: json['cardCode'],
        cardName: json['cardName'],
        docTotal: double.parse(json['docTotal'].toString()),
        grosProfit: double.parse(json['grosProfit'].toString()),
        ownerCode: json['ownerCode'],
        groupNum: int.parse(json['groupNum'].toString()),
        payType: json['payType']);
  }

  factory Order.defaultOrder() {
    return Order(
        docEntry: 0,
        docNum: 0,
        docStatus: '',
        docDate: DateTime.now(),
        cardCode: '',
        cardName: '',
        docTotal: 0,
        grosProfit: 0,
        ownerCode: 0,
        groupNum: 0,
        payType: '');
  }

  static Future<List<Order>> fetchOrders(uid) async {
    final response = await http.get(
        Uri.http(await getIpAddressRoot(), '/api/SapOrder/getsaporder', {'code': uid.toString()}));
    return compute(parseProps, response.body);
  }

  static List<Order> parseProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;
    return props.map<Order>((propJson) => Order.fromJson(propJson)).toList();
  }

  static Future<String> getOrderCount() async {
    return (await getListOrder()).length.toString();
  }

  static Future<String> getOrdersSumm() async {
    double result = 0;
    for (Order order in (await getListOrder())) {
      result += order.docTotal;
    }
    return result.toStringAsFixed(2);
  }

  Map<String, dynamic> toMap() {
    return {
      'docEntry': docEntry,
      'docNum': docNum,
      'docStatus': docStatus,
      'docDate': docDate.toString(),
      'cardCode': cardCode,
      'cardName': cardName,
      'docTotal': docTotal,
      'grosProfit': grosProfit,
      'ownerCode': ownerCode,
      'groupNum': groupNum,
      'payType': payType
    };
  }
}
