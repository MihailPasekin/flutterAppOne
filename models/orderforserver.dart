import 'package:testflutterapp/models/item.dart';

class OrderForServer {
  String OrderCode = '';
  String OrderDate = '';
  String OrderClient;
  String? OrderSeller;
  int GroupNum;
  List<Item> OrderItems;
  String Comment = '';

  OrderForServer(
      {required this.OrderClient,
      required this.OrderSeller,
      required this.OrderItems,
      required this.GroupNum,
      required this.Comment});

  Map<String, dynamic> toJson() {
    return {
      "OrderCode": OrderCode,
      "OrderDate": OrderDate,
      "OrderClient": OrderClient,
      "OrderSeller": OrderSeller,
      "OrderItems": OrderItems,
      "GroupNum": GroupNum,
      "Comment": Comment
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "OrderCode": OrderCode,
      "OrderDate": OrderDate,
      "OrderClient": OrderClient,
      "OrderSeller": OrderSeller,
      "OrderItems": OrderItems,
      "GroupNum": GroupNum,
      "Comment": Comment
    };
  }

  factory OrderForServer.defaultOrderForServer() {
    return OrderForServer(
        OrderClient: '',
        OrderSeller: '',
        OrderItems: List.empty(growable: false),
        GroupNum: 0,
        Comment: '');
  }

  factory OrderForServer.fromJson(Map<String, dynamic> json) {
    return OrderForServer(
        OrderClient: json['OrderClient'],
        OrderSeller: json['OrderSeller'],
        OrderItems: List.generate(json['OrderItems'].length,
            (index) => Item.fromOrderForEditor(json['OrderItems'][index])),
        GroupNum: int.parse(json['GroupNum'].toString()),
        Comment: json['Comment'] ?? '');
  }
}
