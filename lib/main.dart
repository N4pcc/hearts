import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hearts/providers/app_state.dart';
import 'package:hearts/providers/user.dart';
import 'package:hearts/screens/splash.dart';
import 'controllers/carousel_controller.dart';
import 'helpers/constant/constants.dart';
import 'helpers/dependency_injection.dart';
import 'helpers/themedata.dart';
import 'locators/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'notifications.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  DependencyInjection.init();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
      Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  print(notificationAppLaunchDetails?.notificationResponse?.payload);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  NotificationController.init();
  await Geolocator.requestPermission();
  setupLocator();
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStateProvider>.value(
        value: AppStateProvider(),
      ),
      ChangeNotifierProvider<UserProvider>.value(
        value: UserProvider(),
      ),
    ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HEARTS',
      navigatorKey: navigatorKey,
      themeMode: ThemeMode.light,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      // theme: ThemeData(
      //   primarySwatch: Colors.red,
      // ),
      home: const SplashScreen(),
    ),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     UserProvider auth = Provider.of<UserProvider>(context);
//     switch (auth.status) {
//       case Status.Uninitialized:
//         return const SplashScreen();
//       case Status.Unauthenticated:
//       case Status.Authenticating:
//         return LoginScreen();
//       case Status.Authenticated:
//         return MyHomePage();
//       default:
//         return LoginScreen();
//     }
//   }
// }
