import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../global/global.dart';
import '../src/src.dart';

const String signIn = "/",
    signup = "signup",
    home = "home",
    notification = "notification",
    accounts = "account",
    monitorDetail = "monitor_detail",
    advisorComment = "advisor_comment",
    signaturePage = "signature";

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

      if (!status && signInP && !signUnP) {
        return "/";
      }
      if (!copy.state && status && (!homeP || homeP)) {
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
          GoRoute(
              name: monitorDetail,
              path: "/$monitorDetail/:monitorId",
              builder: (context, state) {
                return MonitorDetail(
                  key: state.pageKey,
                  monitorId: state.params["monitorId"] ?? "",
                );
              },
              routes: const []),
          GoRoute(
            name: advisorComment,
            path: "/$advisorComment",
            builder: (context, state) {
              return MonitorAdvisorComments(
                key: state.pageKey,
              );
            },
          ),
          GoRoute(
            name: signaturePage,
            path: "/$signaturePage",
            builder: (context, state) {
              return HandSignatureupload(
                key: state.pageKey,
              );
            },
          ),
        ],
      ),
    ],
  );
});
