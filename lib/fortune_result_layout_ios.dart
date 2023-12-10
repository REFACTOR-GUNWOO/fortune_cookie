import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/fortune_result.dart';
import 'package:fortune_cookie_flutter/fortune_result_ios.dart';
import 'package:fortune_cookie_flutter/fortune_result_layout.dart';
import 'category.dart';

class FortuneResultLayoutIos extends StatefulWidget {
  // final String fortuneCategory;
  final Category targetCategory;
  const FortuneResultLayoutIos(Category? category,
      {Key? key, required this.targetCategory})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneResultLayoutIos> createState() => _FortuneResultLayoutIosState();
}

class _FortuneResultLayoutIosState extends State<FortuneResultLayoutIos>
    with TickerProviderStateMixin {
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

  late TabController _tabController;
  List<Category> categories = getCategories();
  int _currentTabIndex = 0;
  @override
  void initState() {
    super.initState();

    // SingleTickerProviderStateMixin를 상속 받아서
    // vsync에 this 형태로 전달해야 애니메이션이 정상 처리된다.
    _tabController = TabController(vsync: this, length: getCategories().length);
    _tabController.animation?.addListener(onTabSwiped);
    if (widget.targetCategory != null) {
      _tabController.index = (getCategories()
              .indexWhere((e) => e.name == widget.targetCategory?.name) ??
          0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Color getBackgroundColor(int index) {
    List<Color> colors = [
      Color(0xFFFFE5B9),
      Color(0xFFC9D3DB),
      Color(0xFFFFE5A3),
      Color(0xFFFFC1C1)
    ];
    return colors[index];
  }

  void onTabSwiped() {
    int indexChange = _tabController.offset.round();
    int index = _tabController.index + indexChange;

    if (index != _currentTabIndex) {
      setState(() => _currentTabIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    void togglePage() {
      Navigator.pushNamed(context, '/main',
          arguments: getCategories()[_tabController.index]);
    }

    final bool byCookieOpen = (ModalRoute.of(context)!.settings.arguments
                as FortuneResultRouteArguments?)
            ?.byCookieOpen ??
        false;

    return Container(
        decoration: BoxDecoration(color: getBackgroundColor(_currentTabIndex)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: null,
            floatingActionButton: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: 180,
                    height: 62,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50.0), // 원하는 모양 및 크기 설정
                      ),
                      child: Text(
                        "명언 뽑으러가기",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: togglePage,
                      tooltip: 'Increment',
                      backgroundColor: Color.fromARGB(255, 43, 43, 43),
                      heroTag: null,
                    )),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height / 10,
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
            body: TabBarView(
                controller: _tabController,
                children: categories
                    .map((e) => Platform.isAndroid
                        ? FortuneResult(
                            fortuneCategory: e, byCookieOpen: byCookieOpen)
                        : FortuneResultIos(
                            fortuneCategory: e, byCookieOpen: byCookieOpen))
                    .toList())));
  }
}
