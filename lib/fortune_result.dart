import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/category_icon.dart';
import 'package:fortune_cookie_flutter/synerge.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category.dart';

class FortuneResult extends StatefulWidget {
  final Category fortuneCategory;
  const FortuneResult({Key? key, required this.fortuneCategory})
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("확신이 서지 않아\n힘든 날이군요", style: TextStyle(fontSize: 20)),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("운세를 뽑아보세요", style: TextStyle(fontSize: 20)),
        ],
      );
    }
  }

  String getTimerString() {
    DateFormat formatter = DateFormat('M월 d일');
    DateTime tomorrowStartTime = DateTime(_now.add(Duration(days: 1)).year,
        _now.add(Duration(days: 1)).month, _now.add(Duration(days: 1)).day);
    String differenceHour =
        tomorrowStartTime.difference(_now).inHours.toString();
    int differenceMinute = tomorrowStartTime.difference(_now).inMinutes % 60;
    int differenceSecond = tomorrowStartTime.difference(_now).inSeconds % 60;
    return "${differenceHour}시간 ${differenceMinute}분 ${differenceSecond}초 뒤\n운세가 초기화돼요";
  }

  @override
  Widget build(BuildContext context) {
    void togglePage() {
      Navigator.pushNamed(context, '/');
    }

    return Center(
        child: Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 100),
        child: Text(
          getTimerString(),
          style: TextStyle(fontSize: 24),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        // color: const Color.fromARGB(255, 193, 182, 182),
        width: 400,
        height: 600,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            child: Column(children: [
              FortuneCategoryIcon(
                  fortuneCategory: widget.fortuneCategory,
                  checked: false,
                  alwaysOpen: true),
              Text("${widget.fortuneCategory.name}",
                  style: TextStyle(fontSize: 20)),
            ]),
          ),
          getResultWidget(),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Synerge(
                  synergeType: "장소",
                  fortuneCategory: widget.fortuneCategory.name,
                ),
                Synerge(
                  synergeType: "컬러",
                  fortuneCategory: widget.fortuneCategory.name,
                ),
                Synerge(
                  synergeType: "물건",
                  fortuneCategory: widget.fortuneCategory.name,
                )
              ],
            ),
          ),
        ]),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/result_card.png"),
            fit: BoxFit.cover,
          ),
        ),
      )
    ]));
  }
}
