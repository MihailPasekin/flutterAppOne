class Photo {
  int PlanId;
  int PlanDetailId;
  DateTime CreatedAt;
  String PhotoName;
  String FullFileName;
  String Period;

  Photo(
      {required this.PlanId,
      required this.PlanDetailId,
      required this.CreatedAt,
      required this.PhotoName,
      required this.FullFileName,
      required this.Period});

  factory Photo.defaultPlanReport() {
    return Photo(
        PlanId: 0,
        PlanDetailId: 0,
        CreatedAt: DateTime.now(),
        PhotoName: '',
        FullFileName: '',
        Period: '');
  }

  Map<String, Object?> toMap() {
    return {
      'PlanId': PlanId,
      'PlanDetailId': PlanDetailId,
      'CreatedAt': CreatedAt.toString(),
      'PhotoName': PhotoName,
      'FullFileName': FullFileName,
      'Period': Period,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'PlanId': PlanId,
      'PlanDetailId': PlanDetailId,
      'CreatedAt': CreatedAt.toIso8601String(),
      'PhotoName': PhotoName,
      'FullFileName': FullFileName,
      'Period': Period,
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      PlanId: json['PlanId'],
      PlanDetailId: json['PlanDetailId'],
      CreatedAt: DateTime.parse(json['CreatedAt']),
      PhotoName: json['PhotoName'],
      FullFileName: json['FullFileName'],
      Period: json['Period'],
    );
  }
}
