import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/src/auth/signin/signin.dart';
import 'package:rpcadvisorapp/src/auth/signup/signup.dart';
import 'package:rpcadvisorapp/src/home/home.dart';
import 'package:rpcadvisorapp/src/home_bottom_nav/home_nav.dart';
import 'package:rpcadvisorapp/src/notifcation/notification.dart';
import 'package:rpcadvisorapp/src/profile/profile.dart';

import '../global/global.dart';

const String signIn = "/",
    signup = "signup",
    home = "home",
    notification = "notification",
    accounts = "account";

final parentKey = GlobalKey<NavigatorState>(debugLabel: "root");
final shellKey = GlobalKey<NavigatorState>(debugLabel: "shell");

final goRouter = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: signIn,
    navigatorKey: parentKey,
    debugLogDiagnostics: true,
    refreshListenable: ref.read(authidentifier),
    redirect: (context, state) {
      final copy = ref.read(isDuplicate.notifier);
      final auth = ref.read(authidentifier);
      final status = auth.statusAuth == AuthStatus.authenticated;
      final signInP = state.subloc == "/";
      final signUnP = state.subloc == "/$signIn";
      final homeP = state.subloc == "/$home";
      final accO = state.subloc == "/$accounts";

      if (!status && signInP && !signUnP) {
        return "/";
      }
      if (!copy.state &&
          status &&
          (!homeP || homeP || accO || !accO) &&
          auth.statusAuth == AuthStatus.authenticated) {
        log("Come Here");
        copy.state = true;
        return "/$home";
      }

      return null;
    },
    routes: [
      GoRoute(
        name: signIn,
        path: signIn,
        builder: (context, state) {
          return SignInScreen(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        name: signup,
        path: "/$signup",
        builder: (context, state) {
          return SignUpScreen(
            key: state.pageKey,
          );
        },
      ),
      ShellRoute(
          navigatorKey: shellKey,
          builder: (context, state, child) => HomeNav(child),
          routes: [
            GoRoute(
              name: home,
              path: "/$home",
              builder: (context, state) {
                return HomeScreen(
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              name: accounts,
              path: "/$accounts",
              builder: (context, state) {
                return ProfileScreen(
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              name: notification,
              path: "/$notification",
              builder: (context, state) {
                return NotifcationScreen(
                  key: state.pageKey,
                );
              },
            ),
          ]),
    ],
  );
});
