import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rpcadvisorapp/firebase_options.dart';
import 'package:rpcadvisorapp/global/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constant/constant.dart';
import 'routes/route_generator.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "hig_importance_channel",
  "High Importance Notification",
  description: "This channel is used for important notifications",
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((x) async {
    await FirebasePushNotif().onInit();
  });

  await FirebasePushNotif.showNotif(message: message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupaBaseCall.urlSupabase,
    anonKey: SupaBaseCall.supabsePubKey,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((x) async => await FirebasePushNotif().onInit());
  await SharedPrefs.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // ref.read(firebaseMessagingProvider).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final goRoute = ref.watch(goRouter);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: CustomColor.kindaRed),
            primaryColor: CustomColor.kindaRed,
          ),
          routeInformationParser: goRoute.routeInformationParser,
          routerDelegate: goRoute.routerDelegate,
          routeInformationProvider: goRoute.routeInformationProvider,
        );
      },
    );
  }
}
