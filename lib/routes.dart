import 'package:flutter/material.dart';
import 'package:fortune_cookie_flutter/fortune_result.dart';
import 'package:fortune_cookie_flutter/result_page.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';

class Routes {
  Routes._();

  static const String resultPage = '/resultPage';
  static const String showRetryAd = '/retryAd';
  static const String fortuneResult = '/fortuneResult';

  static final routes = <String, WidgetBuilder>{
    resultPage: (BuildContext context) => ResultPage(),
    showRetryAd: (BuildContext context) => RetryAd(),
    fortuneResult: (BuildContext context) => FortuneResult(),
  };
}
