import 'package:flutter/material.dart';
import 'package:fortune_cookie_flutter/result_page.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';

class Routes {
  Routes._();

  static const String resultPage = '/resultPage';
  static const String showRetryAd = '/retryAd';

  static final routes = <String, WidgetBuilder>{
    resultPage: (BuildContext context) => ResultPage(),
    showRetryAd: (BuildContext context) => RetryAd(),
  };
}
