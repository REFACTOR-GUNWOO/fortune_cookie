import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class FortuneCookie extends StatefulWidget {
  final String fortuneCategory;
  const FortuneCookie({Key? key, required this.fortuneCategory})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneCookie> createState() => _FortuneCookieState();
}

class _FortuneCookieState extends State<FortuneCookie> {
  late bool _opened = false;

  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  String _getOpenedKey() {
    return "${widget.fortuneCategory}.fortueCookie.opened";
  }

  _loadFortuneCookieInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _opened = _prefs.getBool(_getOpenedKey()) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFortuneCookieInfo();
  }

  SvgPicture _getCookieImage() {
    if (!_opened) {
      return SvgPicture.asset("assets/images/fortune_cookie.svg");
    } else {
      return SvgPicture.asset("assets/images/fortune_cookie_opened.svg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Lottie.asset('assets/lotties/touch.json'),
      // Container(
      //     width: 400,
      //     height: 400,
      //     child: IconButton(
      //         style: const ButtonStyle(iconSize: MaterialStatePropertyAll(400)),
      //         onPressed: () async {
      //           SharedPreferences _prefs =
      //               await SharedPreferences.getInstance();
      //           if (_opened)
      //             setState(() {
      //               _opened = false;
      //             });
      //           else
      //             setState(() {
      //               _opened = true;
      //             });

      //           await _prefs.setBool(_getOpenedKey(), _opened);
      //         },
      //         icon: _getCookieImage())),
      Text("오늘 나의 ${widget.fortuneCategory}를 뽑아보세요")
    ]));
  }
}
