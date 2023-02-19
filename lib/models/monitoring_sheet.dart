// To parse this JSON data, do
//
//     final monitoringSheet = monitoringSheetFromJson(jsonString);

import 'dart:convert';

MonitoringSheet monitoringSheetFromJson(String str) =>
    MonitoringSheet.fromJson(json.decode(str));

String monitoringSheetToJson(MonitoringSheet data) =>
    json.encode(data.toJson());

class MonitoringSheet {
  MonitoringSheet({
    this.id,
    this.idAdivsor,
    this.idStudent,
    this.zCode,
    this.approveTitle,
    this.outlineProposal,
    this.outlineDefense,
    this.dataGathering,
    this.manuscript,
    this.finalOralPrep,
    this.routing,
    this.plagiarism,
    this.approval,
    this.finalOutput,
    this.subjectTeacher,
    this.ressearchCoordinator,
    this.status,
    this.thesisTitle,
    this.current,
    this.createdAt,
  });

  int? id;
  IdAdivsor? idAdivsor;
  IdStudent? idStudent;
  String? zCode;
  bool? approveTitle;
  bool? outlineProposal;
  bool? outlineDefense;
  bool? dataGathering;
  bool? manuscript;
  bool? finalOralPrep;
  bool? routing;
  bool? plagiarism;
  bool? approval;
  bool? finalOutput;
  bool? subjectTeacher;
  bool? ressearchCoordinator;
  String? status;
  String? thesisTitle;
  String? current;
  DateTime? createdAt;

  MonitoringSheet copyWith({
    int? id,
    IdAdivsor? idAdivsor,
    IdStudent? idStudent,
    String? zCode,
    bool? approveTitle,
    bool? outlineProposal,
    bool? outlineDefense,
    bool? dataGathering,
    bool? manuscript,
    bool? finalOralPrep,
    bool? routing,
    bool? plagiarism,
    bool? approval,
    bool? finalOutput,
    bool? subjectTeacher,
    bool? ressearchCoordinator,
    String? status,
    String? thesisTitle,
    String? current,
    DateTime? createdAt,
  }) =>
      MonitoringSheet(
        id: id ?? this.id,
        idAdivsor: idAdivsor ?? this.idAdivsor,
        idStudent: idStudent ?? this.idStudent,
        zCode: zCode ?? this.zCode,
        approveTitle: approveTitle ?? this.approveTitle,
        outlineProposal: outlineProposal ?? this.outlineProposal,
        outlineDefense: outlineDefense ?? this.outlineDefense,
        dataGathering: dataGathering ?? this.dataGathering,
        manuscript: manuscript ?? this.manuscript,
        finalOralPrep: finalOralPrep ?? this.finalOralPrep,
        routing: routing ?? this.routing,
        plagiarism: plagiarism ?? this.plagiarism,
        approval: approval ?? this.approval,
        finalOutput: finalOutput ?? this.finalOutput,
        subjectTeacher: subjectTeacher ?? this.subjectTeacher,
        ressearchCoordinator: ressearchCoordinator ?? this.ressearchCoordinator,
        status: status ?? this.status,
        thesisTitle: thesisTitle ?? this.thesisTitle,
        current: current ?? this.current,
        createdAt: createdAt ?? this.createdAt,
      );

  factory MonitoringSheet.fromJson(Map<String, dynamic> json) =>
      MonitoringSheet(
        id: json["id"],
        idAdivsor: json["id_adivsor"] == null
            ? null
            : IdAdivsor.fromJson(json["id_adivsor"]),
        idStudent: json["id_student"] == null
            ? null
            : IdStudent.fromJson(json["id_student"]),
        zCode: json["z_code"],
        approveTitle: json["approve_title"],
        outlineProposal: json["outline_proposal"],
        outlineDefense: json["outline_defense"],
        dataGathering: json["data_gathering"],
        manuscript: json["manuscript"],
        finalOralPrep: json["final_oral_prep"],
        routing: json["routing"],
        plagiarism: json["plagiarism"],
        approval: json["approval"],
        finalOutput: json["final_output"],
        subjectTeacher: json["subject_teacher"],
        ressearchCoordinator: json["ressearch_coordinator"],
        status: json["status"],
        thesisTitle: json["thesis_title"],
        current: json["current"] == null ? null : json["current"]!,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_adivsor": idAdivsor?.toJson(),
        "id_student": idStudent?.toJson(),
        "z_code": zCode,
        "approve_title": approveTitle,
        "outline_proposal": outlineProposal,
        "outline_defense": outlineDefense,
        "data_gathering": dataGathering,
        "manuscript": manuscript,
        "final_oral_prep": finalOralPrep,
        "routing": routing,
        "plagiarism": plagiarism,
        "approval": approval,
        "final_output": finalOutput,
        "subject_teacher": subjectTeacher,
        "ressearch_coordinator": ressearchCoordinator,
        "status": status,
        "thesis_title": thesisTitle,
        "current": current,
        "created_at": createdAt?.toIso8601String(),
      };
}

class IdAdivsor {
  IdAdivsor({
    this.advisorId,
  });

  String? advisorId;

  IdAdivsor copyWith({
    String? advisorId,
  }) =>
      IdAdivsor(
        advisorId: advisorId ?? this.advisorId,
      );

  factory IdAdivsor.fromJson(Map<String, dynamic> json) => IdAdivsor(
        advisorId: json["advisor_id"],
      );

  Map<String, dynamic> toJson() => {
        "advisor_id": advisorId,
      };
}

class IdStudent {
  IdStudent({
    this.studentsId,
  });

  List<StudentsId>? studentsId;

  IdStudent copyWith({
    List<StudentsId>? studentsId,
  }) =>
      IdStudent(
        studentsId: studentsId ?? this.studentsId,
      );

  factory IdStudent.fromJson(Map<String, dynamic> json) => IdStudent(
        studentsId: json["students_id"] == null
            ? []
            : List<StudentsId>.from(
                json["students_id"]!.map((x) => StudentsId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "students_id": studentsId == null
            ? []
            : List<dynamic>.from(studentsId!.map((x) => x.toJson())),
      };
}

class StudentsId {
  StudentsId({
    this.idStudent,
  });

  String? idStudent;

  StudentsId copyWith({
    String? idStudent,
  }) =>
      StudentsId(
        idStudent: idStudent ?? this.idStudent,
      );

  factory StudentsId.fromJson(Map<String, dynamic> json) => StudentsId(
        idStudent: json["id_student"],
      );

  Map<String, dynamic> toJson() => {
        "id_student": idStudent,
      };
}
