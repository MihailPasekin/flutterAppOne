class Invoice {
  int DocEntry;
  int DocNum;
  DateTime DocDate;
  String CardCode;
  String CardName;
  double DocTotal;
  int OwnerCode;
  String DocStatus; 
  int GroupNum;
  double PaySum = 0;
  
  Invoice({
    required this.DocEntry,
    required this.DocNum,
    required this.DocDate,
    required this.CardCode,
    required this.CardName,
    required this.DocTotal,
    required this.OwnerCode,
    required this.DocStatus,
    required this.GroupNum,
    required this.PaySum
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        DocEntry: int.parse(json['DocEntry'].toString()),
        DocNum: int.parse(json['DocNum'].toString()),
        DocDate: DateTime.parse(json['DocDate'].toString()),
        CardCode: json['CardCode'].toString(),
        CardName: json['CardName'].toString(),
        DocTotal: double.parse(json['DocTotal'].toString()),
        OwnerCode: int.parse(json['OwnerCode'].toString()),
        DocStatus: json['DocStatus'],
        GroupNum: int.parse(json['GroupNum'].toString()),
        PaySum: double.parse(json['PaySum'].toString())
    );
  }

  Map<String,dynamic> toJson(){
    return {
        "DocEntry" : DocEntry.toString(),
        "DocNum" : DocNum.toString(),
        "DocDate" : DocDate.toIso8601String(),
        "CardCode" : CardCode,
        "CardName" : CardName,
        "DocTotal" : DocTotal.toString(),
        "OwnerCode": OwnerCode.toString(),
        "DocStatus" : DocStatus,
        "GroupNum" : GroupNum.toString(),
        "PaySum": PaySum.toString()
    };
  }
}