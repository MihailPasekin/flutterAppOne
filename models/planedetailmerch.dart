class PlanDetail {
  int PlanDetailId;
  int PlanId;
  int CastomerId;
  String PlanDeteilStatus;
  DateTime CreatedAt;
  DateTime UpdatedAt;
  int CreatedUserId;
  String CardName;
  String CardCode;

  PlanDetail({
    required this.PlanDetailId,
    required this.PlanId,
    required this.CastomerId,
    required this.PlanDeteilStatus,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.CreatedUserId,
    required this.CardName,
    required this.CardCode,
  });
  factory PlanDetail.defaultPlanDetail() {
    return PlanDetail(
        PlanDetailId: 0,
        PlanId: 0,
        CastomerId: 0,
        PlanDeteilStatus: '',
        CreatedAt: DateTime.now(),
        UpdatedAt: DateTime.now(),
        CreatedUserId: 0,
        CardName: '',
        CardCode: '');
  }
  Map<String, dynamic> toMap() {
    return {
      "PlanDetailId": PlanDetailId,
      "PlanId": PlanId,
      "CastomerId": CastomerId,
      "PlanDeteilStatus": PlanDeteilStatus,
      "CreatedAt": CreatedAt.toString(),
      "UpdatedAt": UpdatedAt.toString(),
      "CreatedUserId": CreatedUserId,
      "CardName": CardName,
      "CardCode": CardCode
    };
  }

  factory PlanDetail.fromJson(Map<String, dynamic> json) {
    return PlanDetail(
        PlanDetailId: json['PlanDetailId'],
        PlanId: json['PlanId'],
        CastomerId: json['CastomerId'],
        PlanDeteilStatus: json['PlanDeteilStatus'],
        CreatedAt: DateTime.parse(json['CreatedAt']),
        UpdatedAt: DateTime.parse(json['UpdatedAt']),
        CreatedUserId: json['CreatedUserId'],
        CardName: json['CardName'],
        CardCode: json['CardCode']);
  }
}
