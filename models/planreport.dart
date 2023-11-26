import 'package:testflutterapp/models/photo.dart';

class PlanReport {
  int EmpId;
  int PlanId;
  int PlanDetailId;
  DateTime CreatedAt;
  List<Photo> Photos;

  PlanReport({
    required this.EmpId,
    required this.PlanId,
    required this.PlanDetailId,
    required this.CreatedAt,
    required this.Photos,
  });

  factory PlanReport.defaultPlanReport() {
    return PlanReport(
      EmpId: 0,
      PlanId: 0,
      PlanDetailId: 0,
      CreatedAt: DateTime.now(),
      Photos: List.empty(growable: true),
    );
  }

  factory PlanReport.fromJson(Map<String, dynamic> json) {
    return PlanReport(
        PlanId: json['PlanId'],
        EmpId: json['EmpId'],
        PlanDetailId: json['PlanDetailId'],
        CreatedAt: DateTime.parse(json['CreatedAt']),
        Photos: List.generate(json['Photos'].length,
            (index) => Photo.fromJson(json['Photos'][index])));
  }

  Map<String, dynamic> toMap() {
    return {
      'EmpId': EmpId,
      'PlanId': PlanId,
      'PlanDetailId': PlanDetailId,
      'CreatedAt': CreatedAt.toString(),
      'Photos': Photos,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'EmpId': EmpId,
      'PlanId': PlanId,
      'PlanDetailId': PlanDetailId,
      'CreatedAt': CreatedAt.toIso8601String(),
      'Photos': Photos,
    };
  }
}
