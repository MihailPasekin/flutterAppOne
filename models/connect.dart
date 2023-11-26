import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:testflutterapp/dbworker.dart';
import 'package:testflutterapp/models/user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testflutterapp/models/connstring.dart';

const storage = FlutterSecureStorage();
var client = http.Client();

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
};

Future loginProps(User users) async {
  final url = Uri.http(await getIpAddressRoot(),
      '/api/SapEmploye/getsapemployebycode', {'code': users.empId.toString()});
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    Map<String, dynamic> temp = json.decode(response.body);
    User user = User.fromJson(temp);
    await createUser(user);
    return true;
  } else {
    return false;
  }
}
