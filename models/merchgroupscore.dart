
class MerchGroupScore {
  int visitId;
  int groupId;

  MerchGroupScore({required this.visitId, required this.groupId});

  factory MerchGroupScore.fromJson(Map<String, dynamic> json) {
    return MerchGroupScore(
      visitId: json['visitId'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "visitId": visitId,
      "groupId": groupId,
    };
  }

  factory MerchGroupScore.defaultItem() {
    return MerchGroupScore(visitId: 0, groupId: 0);
  }
}
