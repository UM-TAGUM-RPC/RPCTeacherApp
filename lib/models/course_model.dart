// To parse this JSON data, do
//
//     final course = courseFromJson(jsonString);

import 'dart:convert';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  Course({
    this.id,
    this.createdAt,
    this.courseName,
    this.subjectCode,
    this.courseDepartment,
  });

  int? id;
  DateTime? createdAt;
  String? courseName;
  String? subjectCode;
  String? courseDepartment;

  Course copyWith({
    int? id,
    DateTime? createdAt,
    String? courseName,
    String? subjectCode,
    String? courseDepartment,
  }) =>
      Course(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        courseName: courseName ?? this.courseName,
        subjectCode: subjectCode ?? this.subjectCode,
        courseDepartment: courseDepartment ?? this.courseDepartment,
      );

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        courseName: json["courseName"],
        subjectCode: json["subjectCode"],
        courseDepartment: json["courseDepartment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "courseName": courseName,
        "subjectCode": subjectCode,
        "courseDepartment": courseDepartment,
      };

  @override
  bool operator ==(other) {
    if (other is! Course) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
