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

class _FortuneCookieState extends State<FortuneCookie>
    with SingleTickerProviderStateMixin {
  late bool _opened = false;
  late final AnimationController _controller;

  int _counter = 0;
  void _incrementCounter() async {
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
    _controller = AnimationController(vsync: this);
  }

  Widget _getCookieImage() {
    if (_opened) {
      return SvgPicture.asset("assets/images/fortune_cookie_opened.svg");
    } else {
      return _getCookieLottie();
    }
  }

  LottieBuilder _getCookieLottie() {
    if (_counter > 3) {
      return Lottie.asset(
        'assets/lotties/open.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.setBool(_getOpenedKey(), true);
        },
      );
    } else {
      return Lottie.asset(
        'assets/lotties/touch.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the
          // Lottie file and start the animation.
          _controller..duration = composition.duration;
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          width: 400,
          height: 400,
          child: IconButton(
              style: const ButtonStyle(iconSize: MaterialStatePropertyAll(400)),
              onPressed: () async {
                _controller.reset();
                _controller.forward();
                _incrementCounter();
              },
              icon: _getCookieImage())),
      Text(
        "오늘 나의 ${widget.fortuneCategory}를\n뽑아보세요",
        style: TextStyle(fontSize: 32),
        textAlign: TextAlign.center,
      )
    ]));
  }
}
