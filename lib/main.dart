import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:runnn/admin/sideManuBar/noti/notification_services.dart';
import 'package:runnn/signin_signup_forgot/splash_sceen.dart';
import 'firebase_options.dart';

void main() async {
  Intl.defaultLocale = 'th_TH';
  initializeDateFormatting('th_TH', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  //await FirebaseMessaging.instance.getInitialMessage();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationServices().showNotification(message);
}

//global object for accessing device screen size
late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'T Bus',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                //textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
                textTheme: Typography.blackCupertino),
            home: child,
          );
        },
        child: const SplashScreen());
  }
}
