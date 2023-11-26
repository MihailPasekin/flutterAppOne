class Telemetry {
  int? id;
  int empId;
  String longitude;
  String latitude;
  DateTime createDate;
  int batteryLevel;
  String send;
  DateTime sendDate;

  Telemetry(
      {required this.empId,
      required this.longitude,
      required this.latitude,
      required this.createDate,
      required this.batteryLevel,
      required this.send,
      required this.sendDate});

  Map<String, Object?> toMap() {
    return {
      'empid': empId,
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
      'createdate': createDate.toString(),
      'batterylevel': batteryLevel,
      'send': send.toString(),
      'senddate': sendDate.toString(),
    };
  }
}
