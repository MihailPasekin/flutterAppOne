import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'connstring.dart';

class Item {
  int? id;
  String ItemCode;
  String ItemName;
  String Price;
  String WhsName;
  String ItemCount;
  bool ItemForOrder = false;
  int ItemCountForOrder;
  String PicturName = '';
  String? LocalPictureName = "";
  int ItmsGrpCod;

  Item(
      {this.id,
      required this.ItemCode,
      required this.ItemName,
      required this.Price,
      required this.WhsName,
      required this.ItemCount,
      this.ItemCountForOrder = 0,
      required this.PicturName,
      required this.LocalPictureName,
      required this.ItmsGrpCod});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Price: json['Price'].toString(),
        WhsName: json['WhsName'],
        ItemCount: json['ItemCount'].toString(),
        PicturName: json['PicturName'],
        LocalPictureName: '',
        ItmsGrpCod: json['ItmsGrpCod']);
  }

  factory Item.fromOrderForServer(Map<String, dynamic> json) {
    return Item(
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Price: json['Price'].toString(),
        WhsName: json['WhsName'],
        ItemCount: json['ItemCount'].toString(),
        ItemCountForOrder: json['ItemCountForOrder'],
        PicturName: json['PicturName'],
        LocalPictureName: json['LocalPicturName'],
        ItmsGrpCod: json['ItmsGrpCod']);
  }
  factory Item.fromOrderForEditor(Map<String, dynamic> json) {
    return Item(
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Price: json['Price'].toString(),
        WhsName: json['WhsName'],
        ItemCount: json['ItemCount'].toString(),
        ItemCountForOrder: json['ItemCountForOrder'],
        PicturName: json['PicturName'].toString(),
        LocalPictureName: json['LocalPicturName'],
        ItmsGrpCod: json['ItmsGrpCod']);
  }
  factory Item.itemFromJsonDb(Map<String, dynamic> json) {
    return Item(
        id: int.parse(json['id'].toString()),
        ItemCode: json['ItemCode'],
        ItemName: json['ItemName'],
        Price: json['Price'].toString(),
        WhsName: json['WhsName'],
        ItemCount: json['ItemCount'].toString(),
        PicturName: json['PicturName'],
        LocalPictureName: json['LocalPicturName'],
        ItmsGrpCod: json['ItmsGrpCod']);
  }

  Map<String, dynamic> toJson() {
    return {
      "ItemCode": ItemCode,
      "ItemName": ItemName,
      "Price": Price,
      "WhsName": WhsName,
      "ItemCount": ItemCount,
      "ItemForOrder": ItemForOrder,
      "ItemCountForOrder": ItemCountForOrder,
      "PicturName": PicturName,
      "LocalPicturName": LocalPictureName,
      "ItmsGrpCod": ItmsGrpCod
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "ItemCode": ItemCode,
      "ItemName": ItemName,
      "Price": Price,
      "WhsName": WhsName,
      "ItemCount": ItemCount,
      "PicturName": PicturName,
      "ItmsGrpCod": ItmsGrpCod
    };
  }

  Map<String, dynamic> toMapForUpdateLocalPicture() {
    return {
      //"id":id,
      "ItemCode": ItemCode,
      "ItemName": ItemName,
      "Price": Price,
      "WhsName": WhsName,
      "ItemCount": ItemCount,
      "PicturName": PicturName,
      "LocalPicturName": LocalPictureName,
      "ItmsGrpCod": ItmsGrpCod
    };
  }

  factory Item.defaultItem() {
    return Item(
        ItemCode: '',
        ItemName: '',
        Price: '',
        WhsName: '',
        ItemCount: '',
        PicturName: '',
        LocalPictureName: '',
        ItmsGrpCod: 0);
  }

  @override
  bool operator ==(Object other) => other is Item && ItemCode == other.ItemCode;
  @override
  int get hashCode => Object.hash(ItemCode, ItemName);

  Future<void> putItemProps(String body) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
        Uri.http(await getIpAddressRoot(), '/api/Order/createorder'),
        headers: headers,
        body: body);
    if (kDebugMode) {
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  }

  static Future<List<Item>> fetchItem(uid) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),
        '/api/Item/getitems', {'empid': uid.toString()}));
    return compute(parseItemProps, response.body);
  }

  static List<Item> parseItemProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props.map<Item>((propJson) => Item.fromJson(propJson)).toList();
  }
}
