import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:rpcadvisorapp/models/models.dart';
import 'package:rpcadvisorapp/models/notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentUser = ChangeNotifierProvider<UserProfile>((ref) {
  return UserProfile();
});

class UserProfile extends ChangeNotifier {
  bool isLoading = false, isLoading1 = false;
  UsersModel user = UsersModel();
  List<ForViewProponents> proponents = <ForViewProponents>[];
  List<MonitoringSheet> monitorSheet = <MonitoringSheet>[];
  final base = SupaBaseCall.supabaseService;
  final TextEditingController enterCode = TextEditingController(),
      leaveComment = TextEditingController();

  List<MonitoringSheet> get listFiltered => monitorSheet
      .where((element) =>
          element.status == "PENDING" ||
          element.status == "LACK OF REQUIREMENTS")
      .toList()
    ..sort((x, y) => y.createdAt!.compareTo(x.createdAt!));

  Future<void> getUserprofile() async {
    final userProfile = await base
        .from("users")
        .select()
        .eq("supabase_id", base.auth.currentUser!.id)
        .single();

    user = UsersModel.fromJson(userProfile);
    notifyListeners();
    updateNotifdata();
  }

  void addtoList({MonitoringSheet? sheet}) async {
    monitorSheet.add(sheet!);
    notifyListeners();
  }

  Future<void> listentoSheet() async {
    log("AM CALLED");

    base
        .from("monitoring_sheet")
        .stream(primaryKey: ["id"]).listen((event) async {
      for (var x in event) {
        if (monitorSheet.isNotEmpty) {
          final sheet = MonitoringSheet.fromJson(x);
          final index = monitorSheet.indexWhere((x) => x.id == sheet.id);
          if (index != -1) {
            monitorSheet[index] = sheet;
            notifyListeners();
            if (sheet.idStudent == null ||
                sheet.idStudent?.studentsId == null) {
              proponents.removeWhere((x) => x.zcode == sheet.zCode);
              notifyListeners();
            } else {
              final List<UsersModel> list1 = <UsersModel>[];

              final getListids = sheet.idStudent?.studentsId!;
              try {
                proponents.removeWhere((x) => x.zcode == sheet.zCode);
                // notifyListeners();
              } finally {
                for (var ids in getListids ?? []) {
                  final userProfile = await base
                      .from("users")
                      .select()
                      .eq("supabase_id", ids.idStudent ?? "")
                      .single();
                  final user1 = UsersModel.fromJson(userProfile);
                  list1.add(user1);
                  notifyListeners();
                }
                proponents.add(
                  ForViewProponents(zcode: sheet.zCode, model: list1),
                );
                notifyListeners();
              }
            }
          }
        }
      }
      for (var x in monitorSheet) {
        if (x.idAdivsor!.advisorId == base.auth.currentUser!.id) {
          log("${x.thesisTitle} =>${x.idStudent?.studentsId!.toList().length} CHANGES FROM HERE");
        }
      }
      // monitorSheet
      //   ..clear()
      //   ..addAll(event.map((e) => MonitoringSheet.fromJson(e)));
      // notifyListeners();
    });

    // base.channel('custom-insert-channel').onPostgresChanges(
    //     event: PostgresChangeEvent.all,
    //     schema: "public",
    //     table: "monitoring_sheet",
    //     callback: (callback) {
    //       log("$callback", name: "CHANGES");
    //     });
  }

  Future<void> enterCodeAdvisor() async {
    await base
        .from("monitoring_sheet")
        .update(
          {
            "id_adivsor": {"advisor_id": user.id}
          },
        )
        .eq("z_code", enterCode.text)
        .then(
          // (value) => listentoSheet(),
          (value) => log(value.toString()),
        );
  }

  Future<void> getCurrentMonitorSheets() async {
    try {
      final result = await base
          .from("monitoring_sheet")
          .select()
          .eq("id_adivsor->>advisor_id", base.auth.currentUser!.id);
      final List<dynamic> list = result;
      monitorSheet = list.map((e) => MonitoringSheet.fromJson(e)).toList();
      notifyListeners();
    } finally {
      for (MonitoringSheet monitor in monitorSheet) {
        final List<UsersModel> list1 = <UsersModel>[];
        try {
          final getListids = monitor.idStudent?.studentsId!;
          for (var ids in getListids ?? []) {
            final userProfile = await base
                .from("users")
                .select()
                .eq("supabase_id", ids.idStudent ?? "")
                .single();
            final user1 = UsersModel.fromJson(userProfile);
            list1.add(user1);
          }
        } finally {
          proponents.add(
            ForViewProponents(zcode: monitor.zCode, model: list1),
          );
          notifyListeners();
        }
      }
    }
    //listentoSheet();
  }

  List<UsersModel> returnModel(String? zcode) {
    final findWhere = proponents.where((element) => element.zcode == zcode);
    return findWhere.isNotEmpty ? findWhere.first.model! : [];
  }

  MonitoringSheet getmonitordetail(String? id) {
    final findWhere =
        monitorSheet.where((element) => element.id == int.parse(id!));
    //log(jsonEncode(findWhere.first).toString(), name: "DETAIL CURRENT");
    return findWhere.first;
  }

  String? casesStatus(MonitoringSheet? sheet) {
    if (sheet!.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true &&
        sheet.approval == true &&
        sheet.finalOutput == true) {
      return "COMPLETE";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true &&
        sheet.approval == true) {
      return "Submission of Approved Final Output(Book Form)";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true) {
      return "Approval";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true) {
      return "Plagiarism Check";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true) {
      return "Routing";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true) {
      return "Final Oral Presentation";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true) {
      return "Manuscript for Oral Presentation";
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true) {
      return "Data Gathering";
    } else if (sheet.approveTitle == true && sheet.outlineProposal == true) {
      return "Outline Defense";
    } else if (sheet.approveTitle == true) {
      return "Outline Proposal";
    } else {
      return "Approval of Title";
    }
  }

  Future<void> updateNotifdata() async {
    final List<dynamic> result = await base
        .from("notification_token_device")
        .select()
        .eq("supabase_id", base.auth.currentUser!.id);

    if (result.isNotEmpty) {
      // update it

      if (result.first["token_device"] == SharedPrefs.read(tokenDevice)) {
        ////
        log("No Changes from notif token");
      } else {
        log("Update token");
        await base.from("notification_token_device").update({
          "token_device": SharedPrefs.read(tokenDevice),
        }).eq("supabase_id", base.auth.currentUser!.id);
      }
    } else {
      log("Add user data");
      try {
        await base.from("notification_token_device").insert({
          "supabase_id": base.auth.currentUser!.id,
          "user_id": user.id,
          "token_device": SharedPrefs.read(tokenDevice),
        });
      } on PostgrestException catch (e) {
        log(e.message, name: "From Notif");
      }
    }
  }

  Future<void> approveCurrentStatus(
      {String? id, Function()? onSuccess, Function()? onError}) async {
    final getCurrentModel = getmonitordetail(id!);
    final useCase = useCaseStatus(getCurrentModel);
    try {
      isLoading = true;
      notifyListeners();
      final getCurrentRequest = await base
          .from("monitoring_sheet")
          .select()
          .eq("id", getCurrentModel.id ?? "")
          .single()
          .withConverter<MonitoringSheet>(
              (data) => MonitoringSheet.fromJson(data));
      if (getCurrentRequest.current == casesStatus(getCurrentModel)) {
        if (useCase != null) {
          await base
              .from("monitoring_sheet")
              .update(useCase)
              .eq("id", getCurrentModel.id ?? "");

          if (getCurrentRequest.current ==
              "Submission of Approved Final Output(Book Form)") {
            createNotificationtabledata(
              message:
                  "Please Confirm the thesis titled ${getCurrentModel.thesisTitle} if it's already covered all missing requirements",
              studentId: "3",
              advisorId: "${user.id}",
              monitorId: "${getCurrentModel.id}",
            );
          }
        }

        await base
            .from("monitoring_sheet")
            .update({"current": ""}).eq("id", getCurrentModel.id ?? "");
        getCurrentMonitorSheets();
        sendNotificationonStudents(
          monitorId: "${getCurrentModel.id}",
          title: "Approved ${casesStatus(getCurrentModel)}",
          message:
              "Approved ${casesStatus(getCurrentModel)} for title ${getCurrentModel.thesisTitle}, Congratulations....",
        );
        isLoading = false;
        notifyListeners();
        onSuccess!();
      } else {
        isLoading = false;
        notifyListeners();
        onError!();
      }
    } on PostgrestException catch (e) {
      log(e.message, name: "From Approve");
    }
  }

  Map<String, dynamic>? useCaseStatus(MonitoringSheet? sheet) {
    if (sheet!.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true &&
        sheet.approval == true &&
        sheet.finalOutput == true) {
      return null;
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true &&
        sheet.approval == true) {
      return {
        "final_output": true,
        "final_output_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true &&
        sheet.plagiarism == true) {
      return {
        "approval": true,
        "approval_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true &&
        sheet.routing == true) {
      return {
        "plagiarism": true,
        "plagiarism_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true &&
        sheet.finalOralPrep == true) {
      return {
        "routing": true,
        "routing_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true &&
        sheet.manuscript == true) {
      return {
        "final_oral_prep": true,
        "final_oral_prep_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true &&
        sheet.dataGathering == true) {
      return {
        "manuscript": true,
        "manuscript_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true &&
        sheet.outlineProposal == true &&
        sheet.outlineDefense == true) {
      return {
        "data_gathering": true,
        "data_gathering_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true && sheet.outlineProposal == true) {
      return {
        "outline_defense": true,
        "outline_defense_date": DateTime.now().toIso8601String(),
      };
    } else if (sheet.approveTitle == true) {
      return {
        "outline_proposal": true,
        "outline_proposal_date": DateTime.now().toIso8601String(),
      };
    } else {
      return {
        "approve_title": true,
        "approve_title_date": DateTime.now().toIso8601String(),
      };
    }
  }

  Future<void> leaveaComment(
      {String? id, Function()? onSucess, Function()? onError}) async {
    isLoading1 = true;
    notifyListeners();
    if (leaveComment.text != "" || leaveComment.text.isNotEmpty) {
      await base.from("advisor_comments").insert(
          {"comments": leaveComment.text, "monitor_id": int.parse(id!)});
      isLoading1 = false;
      notifyListeners();
      sendNotificationonStudents(
        monitorId: id,
        title: "Advisor Comment",
        message: "Advisor : ${leaveComment.text}",
      );
      leaveComment.text = "";
      onSucess!();
    } else {
      isLoading1 = false;
      notifyListeners();
      onError!();
    }
  }

  Future<void> sendNotificationonStudents(
      {String? monitorId, String? message, String? title}) async {
    final model = getmonitordetail(monitorId!);
    for (var sheetModel in model.idStudent!.studentsId!) {
      final id = sheetModel.idStudent;
      // find token in table
      try {
        final studentToken = await base
            .from("notification_token_device")
            .select()
            .eq("supabase_id", id ?? "")
            .single();

        // Send Notif
        NotificationSend.sendMessageTo(
          fcmToken: studentToken["token_device"] ?? "",
          title: title ?? "",
          body: message ?? "",
        );

        createNotificationtabledata(
          message: message,
          studentId: "${studentToken["user_id"]}",
          advisorId: "${user.id}",
          monitorId: model.id!.toString(),
        );
      } on PostgrestException catch (e) {
        log(e.message.toLowerCase().toString());
      }
    }
    // NotificationSend.sendMessageTo(
    //   fcmToken: "",
    //   title: title ?? "",
    //   body: message ?? "",
    // );
  }

  Future<void> createNotificationtabledata(
      {String? message,
      String? studentId,
      String? advisorId,
      String? monitorId}) async {
    await base.from("notifications").insert(
      {
        "from_id": int.parse(advisorId!),
        "to_id": int.parse(studentId!),
        "monitor_id": int.parse(monitorId!),
        "message": message,
      },
    );
  }

  List<Notifications> notifications = <Notifications>[];

  Future<void> getNotificationAndShow() async {
    base.from("notifications").stream(
      primaryKey: ['id'],
    ).listen((event) async {
      for (var x in event) {
        final mapdata = Notifications.fromJson(x);

        if (mapdata.toId == user.id) {
          final findLis =
              notifications.where((element) => element.id == mapdata.id);
          if (!findLis.isNotEmpty) {
            notifications.add(mapdata);
            notifyListeners();
          }
        }
      }
    });
  }

  Future<void> markAsRead({bool? all, String? id}) async {
    if (all == true) {
      await base
          .from('notifications')
          .update({"status": "read"}).eq("to_id", int.parse(id!));
      final updateModel = notifications.where((e) => e.toId == int.parse(id));
      for (var x in updateModel) {
        x.status = "read";
        notifyListeners();
      }
    } else {
      await base
          .from('notifications')
          .update({"status": "read"}).eq("id", int.parse(id!));
      final updateModel =
          notifications.firstWhere((e) => e.id == int.parse(id));
      updateModel.status = "read";
      notifyListeners();
    }
  }

  Future<void> deleteSheet({String? id, Function()? onSuccess}) async {
    await base.from("notifications").delete().eq("monitor_id", "$id").select();
    await base
        .from("advisor_comments")
        .delete()
        .eq("monitor_id", "$id")
        .select();
    await base.from("monitoring_sheet").delete().eq("id", "$id").select();
    monitorSheet.removeWhere((x) => "${x.id}" == id);
    notifyListeners();
    onSuccess?.call();
  }

  Future<void> removeStudent(
      {MonitoringSheet? sheet,
      String? studentId,
      Function()? onSuccess}) async {
    await base.from("monitoring_sheet").update({
      "id_student": {
        "students_id": sheet!.idStudent!.studentsId!
            .where((x) => x.idStudent != studentId)
            .map((x) => x.toJson())
            .toList()
      },
    }).eq("id", sheet.id!);
    sendNotifToStudent(
      sheet: sheet,
      studentId: studentId,
    );
    onSuccess?.call();
  }

  Future<void> sendNotifToStudent({
    MonitoringSheet? sheet,
    String? studentId,
  }) async {
    final studentToken = await base
        .from("notification_token_device")
        .select()
        .eq("supabase_id", studentId!)
        .single();

    // Send Notif
    NotificationSend.sendMessageTo(
      fcmToken: studentToken["token_device"] ?? "",
      title: "Removed",
      body:
          "You have been removed by the adviser for being inactive, Please contact your own advisor for reason for the thesis title ${sheet!.thesisTitle}",
    );

    createNotificationtabledata(
      message:
          "You have been removed by the adviser for being inactive, Please contact your own advisor for reason for the thesis title ${sheet.thesisTitle}",
      studentId: "${studentToken["user_id"]}",
      advisorId: "${user.id}",
      monitorId: sheet.id!.toString(),
    );
  }
}
