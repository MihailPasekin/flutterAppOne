import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'connstring.dart';

class DeliveryItem {
  int? id;
  final int DocEntry;
  final String ItemCode;
  final String ItemName;
  final String Price;
  final int Quantity;
  final String PicturName;
  final int DocNum;
  final String BaseRef;
  final int BaseEntry;

  DeliveryItem(
      {required this.DocEntry,
      required this.ItemCode,
      required this.ItemName,
      required this.Price,
      required this.PicturName,
      required this.Quantity,
      required this.DocNum,
      required this.BaseRef,
      required this.BaseEntry});

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      DocEntry: json['DocEntry'],
      ItemCode: json['ItemCode'],
      ItemName: json['ItemName'],
      Price: json['Price'].toString(),
      PicturName: json['PicturName'],
      Quantity: json['Quantity'],
      DocNum: json['DocNum'],
      BaseRef: json['BaseRef'],
      BaseEntry: json['BaseEntry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "DocEntry": DocEntry,
      "ItemCode": ItemCode,
      "ItemName": ItemName,
      "Price": Price,
      "PicturName": PicturName,
      "Quantity": Quantity,
      "DocNum": DocNum,
      "BaseRef": BaseRef,
      "BaseEntry": BaseEntry
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "DocEntry": DocEntry,
      "ItemCode": ItemCode,
      "ItemName": ItemName,
      "Price": Price,
      "PicturName": PicturName,
      "Quantity": Quantity,
      "DocNum": DocNum,
      "BaseRef": BaseRef,
      "BaseEntry": BaseEntry
    };
  }

  factory DeliveryItem.defaultItem() {
    return DeliveryItem(
      DocEntry: 0,
      ItemCode: '',
      ItemName: '',
      Price: '',
      PicturName: '',
      Quantity: 0,
      DocNum: 0,
      BaseRef: '',
      BaseEntry: 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DeliveryItem && ItemCode == other.ItemCode;
  @override
  int get hashCode => Object.hash(ItemCode, ItemName);

  static Future<List<DeliveryItem>> fetchDeliveryItem(int docEntry) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),
        'api/Delivery/getsapdeliveryitem', {'docEntry': docEntry.toString()}));
    return compute(parseItemProps, response.body);
  }

  static Future<List<DeliveryItem>> fetchDeliveryItemByEmpId(int empId) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),
        'api/Delivery/getsapdeliveryitembyempid', {'empId': empId.toString()}));
    return compute(parseItemProps, response.body);
  }

  static List<DeliveryItem> parseItemProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<DeliveryItem>((propJson) => DeliveryItem.fromJson(propJson))
        .toList();
  }
}
