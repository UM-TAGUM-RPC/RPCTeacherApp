import 'dart:developer';

import 'package:rpcadvisorapp/constant/supa_base_keys.dart';
import 'package:rpcadvisorapp/models/monitoring_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FunctionSheet {
  static final base = SupaBaseCall.supabaseService;
  static Future<void> addSheet({
    String? id,
    String? title,
    String? code,
    Function(MonitoringSheet? x)? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      final haveData = await base
          .from("monitoring_sheet")
          .select()
          .eq("thesis_title", title ?? "")
          .single();

      if (haveData != {}) {
        onError!("Thesis title already existed.");
      }
    } on PostgrestException catch (e) {
      log(e.message);
      try {
        final haveData = await base
            .from("monitoring_sheet")
            .select()
            .eq("z_code", code ?? "")
            .single();

        if (haveData != {}) {
          onError!("Code already existed.");
        }
      } on PostgrestException catch (e) {
        log(e.message);
        final sheet = {
          "thesis_title": title,
          "z_code": code,
          "status": "PENDING",
          "id_adivsor": {
            "advisor_id": id,
          },
          // "id_student": {},
          "approve_title": false,
          "outline_proposal": false,
          "outline_defense": false,
          "data_gathering": false,
          "manuscript": false,
          "final_oral_prep": false,
          "routing": false,
          "plagiarism": false,
          "approval": false,
          "final_output": false,
          "subject_teacher": false,
          "ressearch_coordinator": false
        };
        await base
            .from("monitoring_sheet")
            .insert(
              sheet,
            )
            .then((value) {
          final monitor = MonitoringSheet.fromJson(sheet);
          monitor.createdAt = DateTime.now();
          onSuccess!(monitor);
        });
      }
    }
  }
}
