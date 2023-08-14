import 'package:flutter/material.dart';
import 'package:fortune_cookie_flutter/fortune_result.dart';
import 'package:fortune_cookie_flutter/result_page.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';

import 'main.dart';

class Routes {
  Routes._();
  static const String mainPage = '/main';
  static const String resultPage = '/resultPage';
  static const String showRetryAd = '/retryAd';
  static const String fortuneResult = '/fortuneResult';

  static final routes = <String, WidgetBuilder>{
    resultPage: (BuildContext context) => ResultPage(),
    fortuneResult: (BuildContext context) => FortuneResult(),
    mainPage: (BuildContext context) => MyApp()
  };
}
