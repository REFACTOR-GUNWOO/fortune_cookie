import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortune_cookie_flutter/MyHomePageIos.dart';
import 'package:fortune_cookie_flutter/category.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout_ios.dart';
import 'package:fortune_cookie_flutter/result_page.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';
import 'package:fortune_cookie_flutter/setting_page.dart';
import 'package:fortune_cookie_flutter/setting_page_ios.dart';

import 'MyHomePage.dart';

class Routes {
  Routes._();
  static const String mainPage = '/main';
  static const String resultPage = '/resultPage';
  static const String showRetryAd = '/retryAd';
  static const String fortuneResult = '/fortuneResult';
  static const String setting = '/setting';

  static final routes = <String, WidgetBuilder>{
    resultPage: (BuildContext context) => ResultPage(),
    fortuneResult: (BuildContext context) => Platform.isAndroid
        ? FortuneResultLayout(
            (ModalRoute.of(context)!.settings.arguments
                    as FortuneResultRouteArguments)
                .category,
            targetCategory: (ModalRoute.of(context)!.settings.arguments
                    as FortuneResultRouteArguments)
                .category,
          )
        : FortuneResultLayoutIos(
            (ModalRoute.of(context)!.settings.arguments
                    as FortuneResultRouteArguments)
                .category,
            targetCategory: (ModalRoute.of(context)!.settings.arguments
                    as FortuneResultRouteArguments)
                .category,
          ),
    mainPage: (BuildContext context) => Platform.isAndroid
        ? MyHomePage(
            targetCategory:
                ModalRoute.of(context)!.settings.arguments as Category)
        : MyHomePageIos(
            targetCategory:
                ModalRoute.of(context)!.settings.arguments as Category),
    setting: (BuildContext context) =>
        Platform.isAndroid ? SettingPage() : SettingPageIos()
  };
}
