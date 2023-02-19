// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  UsersModel({
    this.id,
    this.idNumber,
    this.email,
    this.confirmationCode,
    this.firstName,
    this.lastName,
    this.middleName,
    this.mobileNumber,
    this.birth,
    this.passwordCopy,
    this.role,
    this.createdAt,
    this.supabaseId,
    this.active,
  });

  int? id;
  String? idNumber;
  String? email;
  String? confirmationCode;
  String? firstName;
  String? lastName;
  String? middleName;
  String? mobileNumber;
  String? birth;
  String? passwordCopy;
  String? role;
  DateTime? createdAt;
  String? supabaseId;
  bool? active;

  UsersModel copyWith({
    int? id,
    String? idNumber,
    String? email,
    String? confirmationCode,
    String? firstName,
    String? lastName,
    String? middleName,
    String? mobileNumber,
    String? birth,
    String? passwordCopy,
    String? role,
    DateTime? createdAt,
    String? supabaseId,
    bool? active,
  }) =>
      UsersModel(
        id: id ?? this.id,
        idNumber: idNumber ?? this.idNumber,
        email: email ?? this.email,
        confirmationCode: confirmationCode ?? this.confirmationCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        birth: birth ?? this.birth,
        passwordCopy: passwordCopy ?? this.passwordCopy,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        supabaseId: supabaseId ?? this.supabaseId,
        active: active ?? this.active,
      );

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        idNumber: json["idNumber"],
        email: json["email"],
        confirmationCode: json["confirmationCode"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        middleName: json["middleName"],
        mobileNumber: json["mobileNumber"],
        birth: json["birth"],
        passwordCopy: json["passwordCopy"],
        role: json["role"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        supabaseId: json["supabase_id"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idNumber": idNumber,
        "email": email,
        "confirmationCode": confirmationCode,
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "mobileNumber": mobileNumber,
        "birth": birth,
        "passwordCopy": passwordCopy,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "supabase_id": supabaseId,
        "active": active,
      };
}
