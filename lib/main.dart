import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:fortune_cookie_flutter/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: Routes.routes);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      if (_counter > 10) {
        Navigator.pushNamed(context, '/resultPage');
        _counter = 0;
      }
    });
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M월 d일');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'forture for future',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.brown),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0),
      backgroundColor: const Color.fromARGB(255, 254, 249, 230),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(children: [
                Text(getToday(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Color.fromARGB(255, 94, 92, 85))),
                const Text('아침 시간대의\n나의 운세를 뽑아보세요',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: Colors.black,
                    )),
              ], crossAxisAlignment: CrossAxisAlignment.start),
              Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 100),
                  child: IconButton(
                    onPressed: () {
                      _incrementCounter();
                    },
                    iconSize: 200,
                    icon: SvgPicture.asset('assets/icons/fortune_cookie.svg',
                        width: 200, height: 200),
                  )),
              const FortuneHistoryContainer()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

const fortuneStringList = [
  "곧 당신의 삶에 큰 기회가 찾아올 것입니다. 준비되어 있으세요.",
  "어제의 실패는 내일의 성공을 위한 단서입니다. 오늘 더 나은 선택을 해보세요.",
  "변화는 불가피한 것입니다. 새로운 상황에 적응하는 능력을 키워보세요.",
  "힘들고 어려운 시기가 있더라도, 항상 희망을 잃지 마세요. 믿을 수 있는 미래가 기다리고 있습니다.",
  "어떤 도전에 직면하더라도, 두려워하지 마세요. 당신은 그것을 이길 수 있는 힘을 갖고 있습니다.",
  "주변 사람들과의 협력은 중요합니다. 서로에게 도움을 주고받을 수 있는 기회를 찾아보세요.",
  "목표를 설정하고 꾸준히 노력하는 것은 성공의 핵심입니다. 포기하지 마세요.",
  "어떤 어려움에 직면하더라도 자신의 내면에 힘을 찾아보세요. 그곳에 해답이 있을 것입니다.",
  "삶은 여행입니다. 여러 경험을 쌓으며 자신을 발전시키세요.",
  "가장 큰 성공은 자신을 인정하고 사랑하는 데서 찾을 수 있습니다. 자기 자신에게 자신감을 갖으세요."
];

class FortuneHistory extends StatelessWidget {
  final String label;

  const FortuneHistory({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
              child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            strutStyle: const StrutStyle(fontSize: 16.0),
            text: TextSpan(
                text: fortuneStringList[0],
                style: const TextStyle(
                    color: Colors.black,
                    height: 1.4,
                    fontSize: 16.0,
                    fontFamily: 'NanumSquareRegular')),
          )),
        ],
      ),
    );
  }
}

class FortuneHistoryContainer extends StatelessWidget {
  const FortuneHistoryContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        shape: RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0, //그림자 깊이
        child: const Row(children: [
          Flexible(
              child: FortuneHistoryCard(
                  checked: true, label: '아침', timeString: '오전 6~9시'),
              fit: FlexFit.tight),
          Flexible(
              child: FortuneHistoryCard(
                  checked: false, label: '점심', timeString: '오전 11~2시'),
              fit: FlexFit.tight),
          Flexible(
              child: FortuneHistoryCard(
                  checked: false, label: '저녁', timeString: '오후 6~9시'),
              fit: FlexFit.tight),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween));
  }
}

class FortuneHistoryCard extends StatelessWidget {
  final String label;
  final String timeString;
  final bool checked;

  Color cardColor() {
    if (checked) {
      return const Color.fromARGB(255, 243, 242, 237);
    } else {
      return Colors.transparent;
    }
  }

  const FortuneHistoryCard(
      {Key? key,
      required this.label,
      required this.timeString,
      required this.checked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: const EdgeInsets.all(8.0),
        color: cardColor(),
        shape: RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/fortune_cookie.svg',
                    width: 60, height: 60),
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 24),
                ),
                Text(timeString,
                    style: const TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 94, 92, 85)))
              ],
            )));
  }
}
