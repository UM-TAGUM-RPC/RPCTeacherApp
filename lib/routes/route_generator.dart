import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rpcadvisorapp/src/monitor_detail/pdf/pdf_view.dart';

import '../global/global.dart';
import '../src/src.dart';

const String signIn = "/",
    signup = "signup",
    home = "home",
    notification = "notification",
    accounts = "account",
    monitorDetail = "monitor_detail",
    advisorComment = "advisor_comment",
    signaturePage = "signature",
    viewPdf = "viewF";

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
      final signInP = state.matchedLocation == "/";
      final signUnP = state.matchedLocation == "/$signIn";
      final homeP = state.matchedLocation == "/$home";

      if (!status && signInP && !signUnP && homeP) {
        return "/";
      }
      if (!copy.state && status && (!homeP || homeP)) {
        log("Come Here");
        copy.state = true;
        return home;
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
      GoRoute(
        name: viewPdf,
        path: "/$viewPdf",
        builder: (context, state) {
          return PdfView(
            key: state.pageKey,
          );
        },
      ),
      // ShellRoute(
      //   navigatorKey: shellKey,
      //   builder: (context, state, child) => HomeNav(child),
      //   routes: [

      //   ],
      // ),

      GoRoute(
        name: home,
        path: "/$home",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: HomeNav(
              Container(),
            ),
          );
        },
      ),
      // GoRoute(
      //       name: home,
      //       path: "/$home",
      //       pageBuilder: (context, state) {
      //         return NoTransitionPage(
      //           child: HomeScreen(
      //             key: state.pageKey,
      //           ),
      //         );
      //       },
      //     ),
      GoRoute(
        name: accounts,
        path: "/$accounts",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: ProfileScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        name: notification,
        path: "/$notification",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: NotifcationScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
          name: monitorDetail,
          path: "/$monitorDetail/:monitorId",
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: MonitorDetail(
                key: state.pageKey,
                monitorId: state.pathParameters["monitorId"] ?? "",
              ),
            );
          },
          routes: const []),
      GoRoute(
        name: advisorComment,
        path: "/$advisorComment",
        pageBuilder: (context, state) {
          return NoTransitionPage(
              child: MonitorAdvisorComments(
            key: state.pageKey,
          ));
        },
      ),
      GoRoute(
        name: signaturePage,
        path: "/$signaturePage",
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: HandSignatureupload(
              key: state.pageKey,
            ),
          );
        },
      ),
    ],
  );
});
