import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fortune_cookie_flutter/GSheetApiConfig.dart';
import 'package:fortune_cookie_flutter/category_icon.dart';
import 'package:fortune_cookie_flutter/stroke_text.dart';
import 'package:fortune_cookie_flutter/synerge.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category.dart';

class FortuneResult extends StatefulWidget {
  final Category fortuneCategory;
  final bool byCookieOpen;
  const FortuneResult(
      {Key? key, required this.fortuneCategory, required this.byCookieOpen})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneResult> createState() => _FortuneResultState();
}

class _FortuneResultState extends State<FortuneResult>
    with TickerProviderStateMixin {
  bool _opened = false;
  late Timer _timer;
  late String? fortuneResult;
  DateTime _now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _loadFortuneInfo();
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
    // initializeFortuneRepository();
    initializeFortuneResult();
  }

  // initializeFortuneRepository() async {
  //   await FortuneRepository.initalWorkSheet();
  // }

  initializeFortuneResult() async {
    // if (!_opened) return;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? saved =
        _prefs.getString("${widget.fortuneCategory.name}.fortueCookie.result");
    print(saved);
    if (saved == null && _opened) {
      FirebaseDatabase _realtime = FirebaseDatabase.instance;
      List<Object?> fortuneList = (await _realtime
              .ref("fortune")
              .child(widget.fortuneCategory.code)
              .get())
          .value as List<Object?>;
      final _random = new Random();
      int randomIndex = _random.nextInt(fortuneList.length);
      String fortune = fortuneList[randomIndex].toString();
      setState(() {
        fortuneResult = fortune;
      });
    } else if (saved != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        fortuneResult = saved;
      });
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _loadFortuneInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _opened = _prefs
              .getBool("${widget.fortuneCategory.name}.fortueCookie.opened") ??
          false;
    });
  }

  Widget getResultWidget() {
    if (_opened) {
      return Text(
        fortuneResult ?? "?",
        style: TextStyle(fontSize: 20, color: Color(0xFF4A4941)),
        textAlign: TextAlign.center,
      );
    } else
      return SvgPicture.asset("assets/icons/?.svg");
  }

  String getTimerString() {
    DateFormat formatter = DateFormat('M월 d일');
    DateTime tomorrowStartTime = DateTime(_now.add(Duration(days: 1)).year,
        _now.add(Duration(days: 1)).month, _now.add(Duration(days: 1)).day);
    String differenceHour =
        tomorrowStartTime.difference(_now).inHours.toString();
    int differenceMinute = tomorrowStartTime.difference(_now).inMinutes % 60;
    int differenceSecond = tomorrowStartTime.difference(_now).inSeconds % 60;
    return "${differenceHour}시간 ${differenceMinute}분 ${differenceSecond}초";
  }

  @override
  Widget build(BuildContext context) {
    void togglePage() {
      Navigator.pushNamed(context, '/main');
    }

    return Center(
        child: Column(children: [
      Container(
          margin: const EdgeInsets.only(
            top: 64,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StrokeText(
                    text: getTimerString(),
                    textStyle: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                    strokeColor: Colors.white,
                    strokeWidth: 2,
                  ),
                  Text(
                    " 뒤",
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
              Text(
                "운세가 초기화돼요",
                style: TextStyle(fontSize: 24),
              )
            ],
          )),
      Expanded(
          child: Container(
        margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 0,
            bottom: min(MediaQuery.of(context).size.height / 8, 100)),
        padding: EdgeInsets.only(left: 26, right: 26, top: 35, bottom: 0),
        // color: const Color.fromARGB(255, 193, 182, 182),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 0),
                child: Column(children: [
                  FortuneCategoryIcon(
                      fortuneCategory: widget.fortuneCategory,
                      checked: false,
                      alwaysOpen: true),
                  Text("${widget.fortuneCategory.name}",
                      style: TextStyle(fontSize: 24)),
                ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.center,
                // width: 150,
                // height: 260,
                child: getResultWidget(),
              ),
              Container(
                padding: EdgeInsets.only(
                    bottom: min(MediaQuery.of(context).size.height / 10, 80)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Synerge(
                      synergeType: SynergeType.place,
                      fortuneCategory: widget.fortuneCategory,
                      cookieOpened: _opened,
                    ),
                    Synerge(
                      synergeType: SynergeType.color,
                      fortuneCategory: widget.fortuneCategory,
                      cookieOpened: _opened,
                    ),
                    Synerge(
                      synergeType: SynergeType.stuff,
                      fortuneCategory: widget.fortuneCategory,
                      cookieOpened: _opened,
                    )
                  ],
                ),
              ),
            ]),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/result_card.png"),
            fit: BoxFit.fill,
          ),
        ),
      ))
    ]));
  }
}
