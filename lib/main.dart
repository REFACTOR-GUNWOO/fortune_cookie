import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout.dart';
import 'package:fortune_cookie_flutter/local_notification_service.dart';
import 'package:intl/intl.dart';
import 'package:fortune_cookie_flutter/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cookie_open_controller.dart';
import 'GSheetApiConfig.dart';
import 'category.dart';
import 'category_icon.dart';
import 'fortune_cookie.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

LocalNotificationService localNotificationService = LocalNotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await localNotificationService.setup();
  // debugPaintSizeEnabled = true;
  final pref = await SharedPreferences.getInstance();
  // String? lastOpenDateString = await pref.getString("last-open-date");
  // if(lastOpenDateString != null){
  // DateTime lastOpenDate =
  //     DateFormat("yyyy-MM-dd").parse(lastOpenDateString);
  //   if(lastOpenDate)
  // }

  checkExpiration();
  runApp(const MyApp());
}

void checkExpiration() async {
  // SharedPreferences에 저장된 날짜 가져오기 (기본값: 0)
  final pref = await SharedPreferences.getInstance();

  final savedTimestamp = pref.getInt('timestamp') ?? 0;
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  print(now.day);
  print(now.hour);
  Duration offsetTime = DateTime.now().timeZoneOffset;
  tz.TZDateTime todayMidnight = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    0,
    0,
  ).subtract(offsetTime);
  print(todayMidnight.day);
  print(todayMidnight.hour);

  if (savedTimestamp < todayMidnight.millisecondsSinceEpoch) {
    // 저장된 데이터가 오늘 자정 이전에 저장되었으므로 만료
    // 데이터 갱신 또는 삭제 작업 수행
    pref.clear(); // 예를 들어 데이터 삭제
    // 데이터 갱신 작업 수행
    pref.setInt('timestamp', now.millisecondsSinceEpoch);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Suite",
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  bool _showTooltip = true;
  bool enableTouchFortuneCookie = true;
  bool showResultPage = false;
  int _currentTabIndex = 0;
  late TabController _tabController;

  void togglePage() {
    Navigator.pushNamed(context, '/fortuneResult',
        arguments: FortuneResultRouteArguments(
            getCategories()[_tabController.index], false));
  }

  String getFloatingButtonText() {
    if (showResultPage) {
      print("운세 뽑으러 가기");
      return ("운세 뽑으러 가기");
    } else {
      print("운세 결과 보기");
      return ("운세 결과 보기");
    }
  }

  void setCurrentTabIndex(int index) {
    print(index);
    setState(() {
      _currentTabIndex = index;
    });
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M월 d일');
    return formatter.format(now);
  }

  late AnimationController _animationController;
  late Animation<double> _animation;
  late FlutterGifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterGifController(vsync: this);
    _tabController = TabController(vsync: this, length: getCategories().length);
    _tabController.addListener(onTabSwiped);
    // _clearData();
  }

  _clearData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onTabSwiped() {
    if (_tabController.index != _tabController.previousIndex)
      // Tab Changed swiping to a new tab
      setCurrentTabIndex(_tabController.index);
  }

  AssetImage getBackgroundByTab(int index) {
    return AssetImage("assets/images/background${index + 1}.png");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: getBackgroundByTab(_tabController.index),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
                padding: EdgeInsets.symmetric(horizontal: 40),
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                controller: _tabController,
                onTap: (index) => {setCurrentTabIndex(index)},
                tabs: getCategories()
                    .map(
                      (e) => Tab(
                          height: 130,
                          icon: ValueListenableBuilder(
                              valueListenable: CookieOpenController(),
                              builder: (BuildContext context,
                                  List<Category> value, Widget? child) {
                                return FortuneCategoryIcon(
                                    fortuneCategory: e,
                                    checked: (getCategories()[_currentTabIndex]
                                                .name ==
                                            e.name) ||
                                        value.any((it) => it.name == e.name),
                                    alwaysOpen: false);
                              }),
                          child: SizedBox(
                              height: 40,
                              width: 100,
                              child: Center(
                                  child: Text(
                                e.tabName,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "Suite"),
                                textAlign: TextAlign.center,
                              )

                                  //  RichText(
                                  //     textAlign: TextAlign.center,
                                  //     overflow: TextOverflow.visible,
                                  //     text: TextSpan(
                                  //       text: e.name,
                                  //       style: TextStyle(
                                  //           fontSize: 18,
                                  //           color: Colors.black,
                                  //           fontFamily: "Suite"),
                                  //     ))

                                  ))),
                    )
                    .toList(),
                indicator: BoxDecoration(),
                splashFactory: NoSplash.splashFactory),
          ),
          body: TabBarView(
              controller: _tabController,
              children: getCategories()
                  .map(
                    (e) => FortuneCookie(
                      category: e,
                    ),
                  )
                  .toList()),
          floatingActionButton: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: 180,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50.0), // 원하는 모양 및 크기 설정
                    ),
                    child: Text(
                      getFloatingButtonText(),
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: togglePage,
                    tooltip: 'Increment',
                    backgroundColor: Color.fromARGB(255, 43, 43, 43),
                    heroTag: null,
                  )),
            ),
            Positioned(
                top: 100,
                right: 10,
                child: IconButton(
                    icon: SvgPicture.asset("assets/icons/setting.svg"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/setting');
                    }))
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
        ));
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
