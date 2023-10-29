import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout.dart';
import 'package:fortune_cookie_flutter/local_notification_service.dart';
import 'package:fortune_cookie_flutter/splash_page.dart';
import 'package:intl/intl.dart';
import 'package:fortune_cookie_flutter/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cookie_open_controller.dart';
import 'category.dart';
import 'category_icon.dart';
import 'fortune_cookie.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

LocalNotificationService localNotificationService = LocalNotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await localNotificationService.setup();
  await Firebase.initializeApp(
    name: "fortuneCookie",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // debugPaintSizeEnabled = true;
  final pref = await SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signInAnonymously();
  await pref.clear();
  checkExpiration();
  runApp(const MyApp());
}

void checkExpiration() async {
  // SharedPreferences에 저장된 날짜 가져오기 (기본값: 0)
  final pref = await SharedPreferences.getInstance();

  final savedTimestamp = pref.getInt('timestamp') ?? 0;
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  Duration offsetTime = DateTime.now().timeZoneOffset;
  tz.TZDateTime todayMidnight = tz.TZDateTime(
    tz.local,
    now.add(offsetTime).year,
    now.add(offsetTime).month,
    now.add(offsetTime).day,
    0,
    0,
  ).subtract(offsetTime);
  print(todayMidnight.day);
  print(todayMidnight.hour);

  if (savedTimestamp < todayMidnight.millisecondsSinceEpoch) {
    // 저장된 데이터가 오늘 자정 이전에 저장되었으므로 만료
    // 데이터 갱신 또는 삭제 작업 수행
    pref.clear(); // 예를 들어 데이터 삭제
    // 데이터 갱신 작업 수행
    pref.setInt('timestamp', now.millisecondsSinceEpoch);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreen(),
        title: 'Flutter Demo',
        builder: (context, child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        theme: ThemeData(
          fontFamily: "Suite",
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: Routes.routes);
  }
}
