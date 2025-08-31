import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpcadvisorapp/constant/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { blank, authenticated, unauthenticated }

final authidentifier = ChangeNotifierProvider((ref) => AuthGlobal());
final isDuplicate = StateProvider<bool>((ref) => false);

class AuthGlobal extends ChangeNotifier {
  final base = SupaBaseCall.supabaseService;
  AuthStatus state = AuthStatus.blank;
  bool isLoading = false;
  AuthStatus get statusAuth => state;

  void statusUserAunthenticated() async {
    base.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        log(data.session!.user.email!, name: "EMAIL");
        state = AuthStatus.authenticated;
        // GoRouter.of(parentKey.currentContext!).goNamed(home);
        notifyListeners();
      } else {
        state = AuthStatus.unauthenticated;
        notifyListeners();
      }
    });
  }

  void signIn(
      {String? email,
      String? password,
      required Function(String) onError,
      Function()? success}) async {
    isLoading = true;
    notifyListeners();
    final result = await base.auth
        .signInWithPassword(email: email, password: password!)
        .onError<AuthException>((e, s) {
      isLoading = false;
      notifyListeners();

      return onError(e.message);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (result.session != null) {
        isLoading = false;
        notifyListeners();
        state = AuthStatus.authenticated;
        success?.call();
      }
    });
  }

  void signOut() async {
    state = AuthStatus.unauthenticated;
    log(state.toString(), name: "AUTH STATE");

    //GoRouter.of(context!).goNamed(r.signIn);
    base.auth.signOut();
    notifyListeners();
  }
}
