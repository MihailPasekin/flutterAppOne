class OrderQueue {
 int? id; 
 String api; 
 String body; 
 DateTime createdDateTime ;
 bool sent = false;
 DateTime sentDateTime;
  
  OrderQueue({
     this.id,
     required this.api,
     required this.body,
     required this.createdDateTime,
     required this.sent,
     required this.sentDateTime
  });
  factory OrderQueue.defaultOrderQueue(){
    return OrderQueue(id: 0, api: '', body: '', createdDateTime: DateTime.now(), sent: false, sentDateTime: DateTime.now());
  }
  factory OrderQueue.fromJson(Map<String, dynamic> json) {
    return OrderQueue(
        id: int.parse(json['id'].toString()),
        api: json['api'],
        body: json['body'],
        createdDateTime: DateTime.parse(json['createdDateTime']),
        sent: json['sent'].toString().toLowerCase() == 'true',
        sentDateTime: DateTime.parse(json['sentDateTime'])
    );
  }

  Map<String,dynamic> toJson(){
    return {
       "id" : id.toString(),
        "api" : api,
        "body" : body,
        "createdDateTime" : createdDateTime.toString(),
        "sent": sent,
        "sentDateTime" : sentDateTime.toString(),
        
    };
  }
   Map<String, dynamic> toMap() {
    return {
      //"id" : id.toString(),
      "api" : api,
      "body" : body,
      "createdDateTime" : createdDateTime.toString(),
      "sent": sent.toString(),
      "sentDateTime" : sentDateTime.toString(),
    };
  }
}