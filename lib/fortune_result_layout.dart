import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/fortune_result.dart';
import 'package:fortune_cookie_flutter/synerge.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category.dart';

class FortuneResultLayout extends StatefulWidget {
  // final String fortuneCategory;
  const FortuneResultLayout({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneResultLayout> createState() => _FortuneResultLayoutState();
}

class _FortuneResultLayoutState extends State<FortuneResultLayout>
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
  @override
  void initState() {
    super.initState();

    // SingleTickerProviderStateMixin를 상속 받아서
    // vsync에 this 형태로 전달해야 애니메이션이 정상 처리된다.
    _tabController = TabController(vsync: this, length: getCategories().length);
  }

  @override
  Widget build(BuildContext context) {
    void togglePage() {
      Navigator.pushNamed(context, '/');
    }

    final Category? category = (ModalRoute.of(context)!.settings.arguments
            as FortuneResultRouteArguments?)
        ?.category;

    if (category != null) {
      _tabController.animateTo(
          getCategories().indexWhere((e) => e.name == category.name) ?? 0);
    }

    final bool byCookieOpen = (ModalRoute.of(context)!.settings.arguments
                as FortuneResultRouteArguments?)
            ?.byCookieOpen ??
        false;

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: togglePage,
              tooltip: 'Increment',
              label: Text("운세 뽑으러 가기"),
              backgroundColor: Color.fromARGB(255, 43, 43, 43),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
            body: TabBarView(
                controller: _tabController,
                children: categories
                    .map((e) => FortuneResult(
                        fortuneCategory: e, byCookieOpen: byCookieOpen))
                    .toList())));
  }
}

class FortuneResultRouteArguments {
  final Category category;
  final bool byCookieOpen;

  FortuneResultRouteArguments(this.category, this.byCookieOpen);
}
