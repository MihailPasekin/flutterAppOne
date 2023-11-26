import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'connstring.dart';

class Delivery {
  int? id;
  final int docEntry;
  final int docNum;
  final String docStatus;
  final String docDate;
  final String cardCode;
  final String cardName;
  final double docTotal;
  final String payType;

  Delivery(
      {this.id,
      required this.docEntry,
      required this.docNum,
      required this.docStatus,
      required this.docDate,
      required this.cardCode,
      required this.cardName,
      required this.docTotal,
      required this.payType});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        id: json['id'],
        docEntry: json['DocEntry'],
        docNum: json['DocNum'],
        docStatus: json['DocStatus'],
        docDate: json['DocDate'],
        cardCode: json['CardCode'],
        cardName: json['CardName'],
        docTotal: double.parse(json['DocTotal'].toString()),
        payType: json['PayType']);
  }

  factory Delivery.fromJsonDB(Map<String, dynamic> json) {
    return Delivery(
        id: json['id'],
        docEntry: json['docEntry'],
        docNum: int.parse(json['docNum'].toString()),
        docStatus: json['docStatus'],
        docDate: json['docDate'],
        cardCode: json['cardCode'],
        cardName: json['cardName'],
        docTotal: double.parse(json['docTotal'].toString()),
        payType: json['payType']);
  }

  factory Delivery.defaultDelivery() {
    return Delivery(
        docEntry: 0,
        docNum: 0,
        docStatus: '',
        docDate: '',
        cardCode: '',
        cardName: '',
        docTotal: 0,
        payType: '');
  }

  static Future<List<Delivery>> fetchDelivery(int code) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),
        '/api/Delivery/getsapdelivery', {'code': code.toString()}));
    return compute(parseProps, response.body);
  }

  static List<Delivery> parseProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;
    return props
        .map<Delivery>((propJson) => Delivery.fromJson(propJson))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'docEntry': docEntry,
      'docNum': docNum,
      'docStatus': docStatus,
      'docDate': docDate,
      'cardCode': cardCode,
      'cardName': cardName,
      'docTotal': docTotal,
      'payType': payType
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'docEntry': docEntry,
      'docNum': docNum,
      'docStatus': docStatus,
      'docDate': docDate,
      'cardCode': cardCode,
      'cardName': cardName,
      'docTotal': docTotal,
      'payType': payType,
    };
  }
}
