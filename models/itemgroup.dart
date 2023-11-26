import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testflutterapp/models/connstring.dart';

class ItemGroup {
  int ItmsGrpCod;
  String ItmsGrpNam;

  ItemGroup({
    required this.ItmsGrpCod,
    required this.ItmsGrpNam,
  });
  factory ItemGroup.fromJson(Map<String, dynamic> json) {
    return ItemGroup(
      ItmsGrpCod: json['ItmsGrpCod'],
      ItmsGrpNam: json['ItmsGrpNam'],
    );
  }

  Map<String, dynamic> toMap() {
    return {"ItmsGrpCod": ItmsGrpCod, "ItmsGrpNam": ItmsGrpNam};
  }

  static Future<List<ItemGroup>> fetchItemGroup() async {
    final response = await http
        .get(Uri.http(await getIpAddressRoot(), '/api/Item/getitemgroups'));
    return compute(parseItemGroupProps, response.body);
  }

  static List<ItemGroup> parseItemGroupProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<ItemGroup>((propJson) => ItemGroup.fromJson(propJson))
        .toList();
  }
}
