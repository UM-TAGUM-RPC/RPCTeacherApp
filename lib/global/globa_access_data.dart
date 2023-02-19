import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:rpcadvisorapp/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentUser = ChangeNotifierProvider<UserProfile>((ref) {
  return UserProfile();
});

class UserProfile extends ChangeNotifier {
  bool isLoading = false, isLoading1 = false;
  UsersModel? user = UsersModel();
  List<ForViewProponents> proponents = <ForViewProponents>[];
  List<MonitoringSheet> monitorSheet = <MonitoringSheet>[];
  final base = SupaBaseCall.supabaseService;
  final TextEditingController enterCode = TextEditingController(),
      leaveComment = TextEditingController();

  Future<void> getUserprofile() async {
    final userProfile = await base
        .from("users")
        .select()
        .eq("supabase_id", base.auth.currentUser!.id)
        .single();

    if (userProfile != null) {
      user = UsersModel.fromJson(userProfile);
      notifyListeners();
      updateNotifdata();
    }
  }

  listentoSheet() {
    base.from("monitoring_sheet").stream(primaryKey: ["id"]).listen((event) {
      for (var x in event) {
        final sheet = MonitoringSheet.fromJson(x);
        if (monitorSheet.isNotEmpty) {
          for (MonitoringSheet monitor in monitorSheet) {
            if (sheet.id == monitor.id) {
              /// update listener
              monitor.current = sheet.current!;
              monitor.approveTitle = sheet.approveTitle;
              monitor.outlineDefense = sheet.outlineDefense;
              monitor.outlineProposal = sheet.outlineProposal;
              monitor.dataGathering = sheet.dataGathering;
              monitor.manuscript = sheet.manuscript;
              monitor.finalOralPrep = sheet.finalOralPrep;
              monitor.routing = sheet.routing;
              monitor.plagiarism = sheet.plagiarism;
              monitor.approval = sheet.approval;
              monitor.finalOutput = sheet.finalOutput;
              monitor.subjectTeacher = sheet.subjectTeacher;
              notifyListeners();
              log(monitor.current ?? "", name: "Current Approve");
            }
          }
        }
      }
    }).onError((e) {
      log(e.toString());
    });
  }

  enterCodeAdvisor() async {
    await base
        .from("monitoring_sheet")
        .update(
          {
            "id_adivsor": {"advisor_id": user!.id}
          },
        )
        .eq("z_code", enterCode.text)
        .then(
          // (value) => listentoSheet(),
          (value) => log(value.toString()),
        );
  }

  getCurrentMonitorSheets() async {
    try {
      final result = await base
          .from("monitoring_sheet")
          .select()
          .eq("id_adivsor->>advisor_id", base.auth.currentUser!.id);
      final List<dynamic> list = result;
      monitorSheet
          .addAll(list.map((e) => MonitoringSheet.fromJson(e)).toList());
      notifyListeners();
    } finally {
      for (MonitoringSheet monitor in monitorSheet) {
        final List<UsersModel> list1 = <UsersModel>[];
        try {
          final getListids = monitor.idStudent!.studentsId!;
          for (var ids in getListids) {
            final userProfile = await base
                .from("users")
                .select()
                .eq("supabase_id", ids.idStudent)
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
    if (sheet!.approveTitle == true) {
      return "Outline Proposal";
    } else if (sheet.outlineProposal == true) {
      return "Outline Defense";
    } else if (sheet.outlineDefense == true) {
      return "Data Gathering";
    } else if (sheet.dataGathering == true) {
      return "Manuscript for Oral Presentation";
    } else if (sheet.manuscript == true) {
      return "Final Oral Presentation";
    } else if (sheet.finalOralPrep == true) {
      return "Routing";
    } else if (sheet.routing == true) {
      return "Plagiarism Check";
    } else if (sheet.plagiarism == true) {
      return "Approval";
    } else if (sheet.approval == true) {
      return "Submission of Approved Final Output(Book Form)";
    } else if (sheet.finalOutput == true) {
      return "COMPLETE";
    } else {
      return "Approval of Title";
    }
  }

  updateNotifdata() async {
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
          "user_id": user!.id,
          "token_device": SharedPrefs.read(tokenDevice),
        });
      } on PostgrestException catch (e) {
        log(e.message, name: "From Notif");
      }
    }
  }

  approveCurrentStatus(
      {String? id, Function()? onSuccess, Function()? onError}) async {
    final getCurrentModel = getmonitordetail(id!);
    final useCase = useCaseStatus(getCurrentModel);
    try {
      isLoading = true;
      notifyListeners();
      final getCurrentRequest = await base
          .from("monitoring_sheet")
          .select()
          .eq("id", getCurrentModel.id)
          .single()
          .withConverter<MonitoringSheet>(
              (data) => MonitoringSheet.fromJson(data));
      if (getCurrentRequest.current == casesStatus(getCurrentModel)) {
        await base
            .from("monitoring_sheet")
            .update(useCase!)
            .eq("id", getCurrentModel.id);
        await base
            .from("monitoring_sheet")
            .update({"current": ""}).eq("id", getCurrentModel.id);
        getCurrentMonitorSheets();
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
    if (sheet!.approveTitle == true) {
      return {"outline_proposal": true};
    } else if (sheet.outlineProposal == true) {
      return {"outline_defense": true};
    } else if (sheet.outlineDefense == true) {
      return {"data_gathering": true};
    } else if (sheet.dataGathering == true) {
      return {"manuscript": true};
    } else if (sheet.manuscript == true) {
      return {"final_oral_prep": true};
    } else if (sheet.finalOralPrep == true) {
      return {"routing": true};
    } else if (sheet.routing == true) {
      return {"plagiarism": true};
    } else if (sheet.plagiarism == true) {
      return {"approval": true};
    } else if (sheet.approval == true) {
      return {"final_output": true};
    } else if (sheet.finalOutput == true) {
      return {};
    } else {
      return {"approve_title": true};
    }
  }

  leaveaComment({String? id, Function()? onSucess, Function()? onError}) async {
    isLoading1 = true;
    notifyListeners();
    if (leaveComment.text != "" || leaveComment.text.isNotEmpty) {
      await base.from("advisor_comments").insert(
          {"comments": leaveComment.text, "monitor_id": int.parse(id!)});
      leaveComment.text = "";
      isLoading1 = false;
      notifyListeners();

      onSucess!();
      // NotificationSend.sendMessageTo(
      //   fcmToken: "",
      //   title: "",
      //   body: "Your Advisor leave a comment"
      // );
    } else {
      isLoading1 = false;
      notifyListeners();
      onError!();
    }
  }
}
