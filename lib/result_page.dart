import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int _counter = 0;
  bool _showTooltip = true;

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
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.black,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 42.0, vertical: 78.0),
            height: 250,
            width: double.infinity,
            color: Colors.white,
            child: const Column(children: [
              Text("오늘 점심 당신의 운세",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.black)),
              Spacer(),
              Text('가까운 사람일수록 소홀히 대하지 말고\n당신의 관심을 적극적으로 표현하는게 좋아요.',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ], crossAxisAlignment: CrossAxisAlignment.start),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              child: const Text('광고보고 운세 다시 뽑기 0/3',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white,
                  ))),
        ]));
  }
}
