import 'package:flutter/material.dart';
import 'package:fortune_cookie_flutter/result_page.dart';

class Routes {
  Routes._();

  static const String resultPage = '/resultPage';

  static final routes = <String, WidgetBuilder>{
    resultPage: (BuildContext context) => ResultPage(),
  };
}
