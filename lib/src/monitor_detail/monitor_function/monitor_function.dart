import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpcadvisorapp/models/models.dart';

import '../../../constant/constant.dart';

final monitorSheetDetails =
    StateNotifierProvider<MonitorFunction, List<AdvisorComment>>(
        (ref) => MonitorFunction());

class MonitorFunction extends StateNotifier<List<AdvisorComment>> {
  MonitorFunction() : super(<AdvisorComment>[]);

  List<AdvisorComment> get list => state;
  final base = SupaBaseCall.supabaseService;
  getAdvisorComments({String? monitorID}) async {
    final result = await base
        .from("advisor_comments")
        .select()
        .eq("monitor_id", int.parse(monitorID!));
    final List<dynamic> list1 = result;
    state = list1.map((e) => AdvisorComment.fromJson(e)).toList();
  }
}
