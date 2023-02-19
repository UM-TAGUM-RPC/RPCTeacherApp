// To parse this JSON data, do
//
//     final advisorComment = advisorCommentFromJson(jsonString);

import 'dart:convert';

AdvisorComment advisorCommentFromJson(String str) =>
    AdvisorComment.fromJson(json.decode(str));

String advisorCommentToJson(AdvisorComment data) => json.encode(data.toJson());

class AdvisorComment {
  AdvisorComment({
    this.id,
    this.comment,
    this.monitorId,
    this.createdAt,
  });

  int? id;
  String? comment;
  int? monitorId;
  DateTime? createdAt;

  AdvisorComment copyWith({
    int? id,
    String? comment,
    int? monitorId,
    DateTime? createdAt,
  }) =>
      AdvisorComment(
        id: id ?? this.id,
        comment: comment ?? this.comment,
        monitorId: monitorId ?? this.monitorId,
        createdAt: createdAt ?? this.createdAt,
      );

  factory AdvisorComment.fromJson(Map<String, dynamic> json) => AdvisorComment(
        id: json["id"],
        comment: json["comments"],
        monitorId: json["monitor_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comments": comment,
        "monitor_id": monitorId,
        "created_at": createdAt?.toIso8601String(),
      };
}
