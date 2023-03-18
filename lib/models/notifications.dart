// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.id,
    this.createdAt,
    this.message,
    this.fromId,
    this.toId,
    this.monitorId,
    this.status,
  });

  int? id;
  DateTime? createdAt;
  String? message;
  int? fromId;
  int? toId;
  int? monitorId;
  String? status;

  Notifications copyWith({
    int? id,
    DateTime? createdAt,
    String? message,
    int? fromId,
    int? toId,
    int? monitorId,
    String? status,
  }) =>
      Notifications(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        message: message ?? this.message,
        fromId: fromId ?? this.fromId,
        toId: toId ?? this.toId,
        monitorId: monitorId ?? this.monitorId,
        status: status ?? this.status,
      );

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        message: json["message"],
        fromId: json["from_id"],
        toId: json["to_id"],
        monitorId: json["monitor_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "message": message,
        "from_id": fromId,
        "to_id": toId,
        "monitor_id": monitorId,
        "status": status,
      };
}
