import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/category.dart';
import 'package:fortune_cookie_flutter/firebase_repository.dart';
import 'package:fortune_cookie_flutter/phrase_repository.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'cookie_open_controller.dart';
import 'fortune_result_layout.dart';

class FortuneCookieIos extends StatefulWidget {
  final Category category;
  const FortuneCookieIos({Key? key, required this.category}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneCookieIos> createState() => _FortuneCookieState();
}

class _FortuneCookieState extends State<FortuneCookieIos>
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
    return "${widget.category.name}.fortueCookie.opened";
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
      return Lottie.asset(
          'assets/lotties/cookie/${widget.category.code}/d.json',
          repeat: false);
    } else {
      return _getCookieLottie();
    }
  }

  LottieBuilder _getCookieLottie() {
    if (_counter < 5) {
      return Lottie.asset(
        'assets/lotties/cookie/${widget.category.code}/a.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the
          // Lottie file and start the animation.
          _controller..duration = composition.duration;
        },
      );
    } else if (_counter < 10) {
      return Lottie.asset(
        'assets/lotties/cookie/${widget.category.code}/b.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the
          // Lottie file and start the animation.
          _controller..duration = composition.duration;
        },
      );
    } else if (_counter < 15) {
      return Lottie.asset(
        'assets/lotties/cookie/${widget.category.code}/c.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the
          // Lottie file and start the animation.
          _controller..duration = composition.duration;
        },
      );
    } else {
      return Lottie.asset(
        'assets/lotties/cookie/${widget.category.code}/d.json',
        repeat: false,
        controller: _controller,
        onLoaded: (composition) async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          await _prefs.setBool(_getOpenedKey(), true);
          CookieOpenController().setCookieOpenState(widget.category);
          _controller.addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              await setFortuneResult(widget.category);
              sleep(Duration(milliseconds: 300));
              Navigator.pushNamed(context, '/fortuneResult',
                  arguments:
                      FortuneResultRouteArguments(widget.category, true));
            }
          });
        },
      );
    }
  }

  Future<void> setFortuneResult(Category category) async {
    // if (!_opened) return;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? saved = _prefs.getString("${category.name}.fortueCookie.result");
    print(saved);
    if (saved == null) {
      if (Platform.isAndroid) {
        String fortune = await FortuneRepository().getFortune(category);
        _prefs.setString("${category.name}.fortueCookie.result", fortune);
      } else {
        BasePhrase phrase = await PhraseRepository().getPhrase(category);
        _prefs.setString(
            "${category.name}.phrase.phraseString", phrase.phraseString);
        _prefs.setString("${category.name}.phrase.author", phrase.author);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  String getTitle() {
    if (widget.category.iosTabName == "랜덤명언")
      return "오늘 당신을 위한\n명언은?";
    else
      return "오늘 당신을 위한\n${widget.category.iosTabName} 명언은?";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Flexible(
          flex: 3,
          child: IconButton(
              iconSize: 350,
              onPressed: () async {
                if (_opened) {
                  return;
                }

                if (_counter == 15) {
                  return;
                }
                HapticFeedback.heavyImpact();
                _controller.reset();
                _controller.forward();
                _incrementCounter();
              },
              icon: _getCookieImage())),
      Flexible(
          flex: 1,
          child: Text(
            getTitle(),
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ))
    ]));
  }
}
