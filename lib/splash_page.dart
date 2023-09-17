import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'MyHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 1.0; // 초기 투명도
  bool splashEnded = false;

  @override
  void initState() {
    super.initState();
    // 일정 시간(예: 2초) 후에 투명도를 0으로 변경하여 화면을 페이드 아웃
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        opacityLevel = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Stack(children: [
          Center(
            child: MyHomePage(),
          ),
          if (!splashEnded)
            AnimatedOpacity(
                onEnd: () => {
                      setState(() => {splashEnded = true})
                    },
                duration: Duration(milliseconds: 200),
                opacity: opacityLevel,
                child: Container(
                  // height: double.infinity,
                  // width: double.infinity,
                  color: Color(0xFFF8C977),
                  alignment: Alignment.center,
                  // margin: EdgeInsets.only(top: 250),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset('assets/lotties/cookie/today/a.json',
                          animate: false, repeat: false, width: 120),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '나의 오늘 운세는?',
                        style: TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 20, right: 20, top: 12),
                      //   padding: EdgeInsets.all(24),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     color: Color(0xFFFEF9E6),
                      //   ),
                      //   child: const Column(children: [
                      //     Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         "더 나은 포춘이가 될 수 있도록",
                      //         style:
                      //             TextStyle(fontSize: 16, color: Color(0xFF7F7E7A)),
                      //       ),
                      //     ),
                      //     Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         "앱 후기를 알려주세요",
                      //         style:
                      //             TextStyle(fontSize: 20, color: Color(0xFF33322E)),
                      //       ),
                      //     ),
                      //   ]),
                      // ),
                    ],
                  ),
                )),
        ]));
  }
}
