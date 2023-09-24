import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gif/flutter_gif.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout.dart';
import 'package:fortune_cookie_flutter/local_notification_service.dart';
import 'package:fortune_cookie_flutter/splash_page.dart';
import 'package:intl/intl.dart';
import 'package:fortune_cookie_flutter/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cookie_open_controller.dart';
import 'category.dart';
import 'category_icon.dart';
import 'fortune_cookie.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  late Animation<double> _animation;
  late FlutterGifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterGifController(vsync: this);
    _tabController = TabController(vsync: this, length: getCategories().length);
    _tabController.animation?.addListener(() {
      int indexChange = _tabController.offset.round();
      int index = _tabController.index + indexChange;

      if (index != _currentTabIndex) {
        setState(() => _currentTabIndex = index);
      }
    });
    // _clearData();
  }

  _clearData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }

  @override
  void dispose() {
    super.dispose();
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
        // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
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
                // padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                // labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 45),
                labelPadding: EdgeInsets.symmetric(horizontal: 0),
                controller: _tabController,
                tabs: getCategories()
                    .map(
                      (e) => Tab(
                          height: 120,
                          iconMargin: EdgeInsets.all(0),
                          child: Column(children: [
                            SizedBox(
                                width: 72,
                                height: 72,
                                child: FortuneCategoryIcon(
                                    fortuneCategory: e,
                                    checked: (getCategories()[_currentTabIndex]
                                            .name ==
                                        e.name),
                                    alwaysOpen: false)),
                            SizedBox(
                                height: 45,
                                width: 80,
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

                                    ))
                          ])),
                    )
                    .toList(),
                indicator: BoxDecoration(),
                splashFactory: NoSplash.splashFactory),
          ),
          extendBody: true,
          body: Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 12),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                    Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: getCategories()
                                .map(
                                  (e) => FortuneCookie(
                                    category: e,
                                  ),
                                )
                                .toList()))
                  ]))),
          floatingActionButton: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: 180,
                  height: 62,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Colors.black),
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
                top: 40,
                right: 10,
                child: IconButton(
                    iconSize: 42,
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
