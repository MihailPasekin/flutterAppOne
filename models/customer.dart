import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'connstring.dart';
import 'package:http/http.dart' as http;

class Customer {

  final String CardCode;
  final String CardName;
  final String Phone1;
  final String Free_Text;
  final String Notes;
  final String U_lat;
  final String U_lng;

  const Customer({
    required this.CardCode,
    required this.CardName,
    required this.Phone1,
    required this.Free_Text,
    required this.Notes,
    required this.U_lat,
    required this.U_lng,
    });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        CardCode: json['CardCode'],
        CardName: json['CardName'],
        Phone1: json['Phone1'],
        Free_Text: json['Free_Text'],
        Notes: json['Notes'],
        U_lat: json['U_lat'],
        U_lng: json['U_lng']
    );
  }

  factory Customer.defaultCustomer() {
    return const Customer(CardCode: '', CardName: '', Phone1: '', Free_Text: '', Notes: '', U_lat: '', U_lng: '');
  }
  
  Map<String, dynamic> toMap() {
    return {
      'CardCode' : CardCode, 
      'CardName' : CardName, 
      'Phone1' : Phone1,
      'Free_Text': Free_Text, 
      'Notes' : Notes, 
      'U_lat' : U_lat,
      'U_lng' : U_lng
    };
  }

  static Future<List<Customer>> fetchCustomer(empId) async {
    final response = await http.get(Uri.http(await getIpAddressRoot(),'/api/Customer/getsapcustomersbyemp', {'empId': empId.toString()}));

    return compute(parseProps, response.body);
  }

  static List<Customer> parseProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props.map<Customer>((propJson) => Customer.fromJson(propJson)).toList();
  }

  Future<List<Customer>> fetchCustomerByUpdateDate(DateTime updateDate) async {
  final response = await http.get(Uri.http(await getIpAddressRoot(),'/api/Customer/getupdatedsapcustomers'));

  return compute(parseProps, response.body);
  }

}