import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/synerge.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category.dart';

class FortuneResult extends StatefulWidget {
  // final String fortuneCategory;
  const FortuneResult({Key? key}) : super(key: key);

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

class _FortuneResultState extends State<FortuneResult> {
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

  @override
  Widget build(BuildContext context) {
    void togglePage() {
      Navigator.pushNamed(context, '/');
    }

    return DefaultTabController(
        length: getCategories().length,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: togglePage,
                tooltip: 'Increment',
                child: Text("운세 뽑으러 가기")),
            body: TabBarView(
                children: getCategories()
                    .map(
                      (e) => Center(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              color: const Color.fromARGB(255, 193, 182, 182),
                              width: 400,
                              height: 600,
                              child: Column(
                                children: [
                                  Text(e.name, style: TextStyle(fontSize: 22)),
                                  Text("확신이 서지 않아\n힘든 날이군요",
                                      style: TextStyle(fontSize: 22)),
                                  Row(
                                    children: [
                                      Synerge(
                                        synergeType: "장소",
                                        fortuneCategory: e.name,
                                      ),
                                      Synerge(
                                        synergeType: "컬러",
                                        fortuneCategory: e.name,
                                      ),
                                      Synerge(
                                        synergeType: "물건",
                                        fortuneCategory: e.name,
                                      )
                                    ],
                                  )
                                ],
                              ))),
                    )
                    .toList())));
  }
}
