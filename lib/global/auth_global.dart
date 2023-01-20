import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { blank, authenticated, unauthenticated }

final authidentifier = ChangeNotifierProvider((ref) => AuthGlobal());
final isDuplicate = StateProvider<bool>((ref) => false);

class AuthGlobal extends ChangeNotifier {
  AuthStatus state = AuthStatus.blank;

  AuthStatus get statusAuth => state;

  void statusUserAunthenticated() async {}

  void signIn({String? email, String? password, BuildContext? context}) async {
    // Future.delayed(const Duration(seconds: 2), () {
    state = AuthStatus.authenticated;
    //   notifyListeners();
    // });

    notifyListeners();
  }

  void signOut() async {
    state = AuthStatus.unauthenticated;

    notifyListeners();
  }
}
