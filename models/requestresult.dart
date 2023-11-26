import 'package:testflutterapp/models/item.dart';

class RequestResult {
  String? status = "";
  List<Item>? errorItemList = List.empty(growable: true);

  RequestResult({this.status, this.errorItemList});

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "errorItemList": errorItemList
    };
  }
  factory RequestResult.fromJson(Map<String, dynamic> json){
    return RequestResult(
      status: json['Status'],
      errorItemList: List.generate(json['ErrorOitmList'].length,
            (index) => Item.fromOrderForEditor(json['ErrorOitmList'][index]))
    );
  }
}