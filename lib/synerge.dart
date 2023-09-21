import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/GSheetApiConfig.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';
import 'package:fortune_cookie_flutter/synerge_open_effect.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'loading.dart';

class Synerge extends StatefulWidget {
  final SynergeType synergeType;
  final String fortuneCategory;
  final bool cookieOpened;
  const Synerge(
      {Key? key,
      required this.fortuneCategory,
      required this.synergeType,
      required this.cookieOpened})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Synerge> createState() => _SynergeState();
}

class _SynergeState extends State<Synerge> {
  bool enabled = false;
  String? value;
  String? color;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSynergeInfo();
    initializeFortuneRepository();
  }

  initializeFortuneRepository() async {
    await SynergeRepository.initalWorkSheet();
  }

  String _getEnableKey() {
    return " ${widget.fortuneCategory}${widget.synergeType}/enbaled";
  }

  String _getSynergeValueKey() {
    return "${widget.fortuneCategory}/${widget.synergeType}/value";
  }

  String _getSynergeColorKey() {
    return "${widget.fortuneCategory}/${widget.synergeType}/value/color";
  }

  _loadSynergeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enabled = (prefs.getBool(_getEnableKey()) ?? false);
      value = (prefs.getString(_getSynergeValueKey()));
      color = (prefs.getString(_getSynergeColorKey()));
    });
  }

  Future<void> _showMyDialog(BaseSynerge synerge) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // 원하는 둥근 테두리 반지름 설정
            ),
            contentPadding: EdgeInsets.only(
                top: 24, bottom: 53, left: 24, right: 24), // 위, 오른쪽, 아래, 왼쪽 순서

            backgroundColor: Color.fromARGB(255, 254, 249, 230),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/close.svg",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  child: Text(
                    '시너지 ${getSynergeLabel(synerge.type)}',
                    style: TextStyle(color: Color(0xFF7F7E7A), fontSize: 18),
                  ),
                  margin: EdgeInsets.only(top: 8),
                ),
                Container(
                  child: getSynergeResult(synerge),
                  margin: EdgeInsets.only(top: 8),
                )
              ],
            ));
      },
    );
  }

  Future<void> _showSynergeOpenEffect() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return SynergeOpenEffect();
      },
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  _setSynergeInfo(SynergeType type) async {
    // if (enabled) return;
    // await Loading.start(context);
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await showRewardFullBanner(() async {
      setState(() {
        isLoading = false;
      });

      // Loading.end(context);
      BaseSynerge synerge = await getSynerge(type);
      /**
       * 각각의 시너지별 결과값 가져와서 저장
       */
      if (enabled) {
        setState(() {
          enabled = false;
        });
      } else {
        setState(() {
          enabled = true;
          value = synerge.value;
          if (type == SynergeType.color) {
            color = (synerge as ColorSynerge).color;
          }
        });
        prefs.setString(_getSynergeValueKey(), synerge.value);
        if (type == SynergeType.color) {
          print("test${(synerge as ColorSynerge).color}");
          prefs.setString(
              _getSynergeColorKey(), (synerge as ColorSynerge).color);
        }
      }
      prefs.setBool(_getEnableKey(), enabled);
      _showMyDialog(synerge);
      _showSynergeOpenEffect();
    });
  }

  SvgPicture _getSynergeImage() {
    if (enabled) {
      return SvgPicture.asset("assets/images/synerge_enabled.svg");
    } else {
      return SvgPicture.asset("assets/images/synerge_disabled.svg");
    }
  }

  Widget getSynergeResult(BaseSynerge synerge) {
    if (synerge.type == SynergeType.color) {
      int intValue = int.tryParse("$color", radix: 16) ?? 0;
      return Column(children: [
        SvgPicture.asset(
          "assets/images/color.svg",
          color: Color(intValue).withOpacity(1),
          width: 78,
          fit: BoxFit.cover,
        ),
        Text(value ?? "",
            style: TextStyle(fontSize: 24, color: Color(0xFF33322E))),
      ]);
    }
    if (synerge.type == SynergeType.place) {
      return Container(
        child: Text(value ?? "",
            style: TextStyle(fontSize: 24, color: Color(0xFF33322E))),
      );
    }
    if (synerge.type == SynergeType.stuff) {
      return Container(
        child: Text(value ?? "",
            style: TextStyle(fontSize: 24, color: Color(0xFF33322E))),
      );
    }
    throw Error();
  }

  Widget getSynergeResultWidget(SynergeType synergeType) {
    if (synergeType == SynergeType.color) {
      int intValue = int.tryParse("$color", radix: 16) ?? 0;
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            child: SvgPicture.asset(
          "assets/images/color.svg",
          color: Color(intValue).withOpacity(1),
          width: 55,
          fit: BoxFit.cover,
        )),
        Text(value ?? "",
            style: TextStyle(fontSize: 20, color: Color(0xFF33322E))),
      ]);
    }
    if (synergeType == SynergeType.place) {
      return Container(
          child: Text(value ?? "",
              style: TextStyle(fontSize: 20, color: Color(0xFF33322E))));
    }
    if (synergeType == SynergeType.stuff) {
      return Container(
          child: Text(value ?? "",
              style: TextStyle(fontSize: 20, color: Color(0xFF33322E))));
    }

    throw Error();
  }

  Widget getWidgetWithLoading() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: value == null
              ? IconButton(
                  icon: _getSynergeImage(),
                  iconSize: 72,
                  onPressed: () async {
                    if (!widget.cookieOpened) {
                      toast(context, "운세를 먼저 확인해주세요");
                      return;
                    }

                    if (isLoading) {
                      toast(context, "광고가 로딩 중이에요!");
                      return;
                    }

                    await _setSynergeInfo(widget.synergeType);
                  },
                )
              : getSynergeResultWidget(widget.synergeType),
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "시너지\n${getSynergeLabel(widget.synergeType)}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 127, 126, 122),
                    fontFamily: "Suite")))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 80, height: 140, child: getWidgetWithLoading());
  }

  void toast(context, text) {
    final fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Color(0xFF2b2b2b),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 내용에 패딩을 추가합니다.
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 1),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            left: 20, // 좌우 마진만 적용
            right: 20,
            bottom: 40,
          );
        });
  }
}

/**
 * 여기서 각 시너지 랜덤으로 받도록
 */
Future<BaseSynerge> getSynerge(SynergeType synergeType) async {
  return await SynergeRepository().getSynerge(synergeType);
}

String getSynergeLabel(SynergeType synergeType) {
  if (synergeType == SynergeType.color) {
    return "컬러";
  }
  if (synergeType == SynergeType.place) {
    return "장소";
  }
  if (synergeType == SynergeType.stuff) {
    return "물건";
  }

  throw Error();
}

enum SynergeType { place, color, stuff }

class BaseSynerge {
  final String value;
  final SynergeType type;

  BaseSynerge(this.value, this.type);
}

class PlaceSynerge extends BaseSynerge {
  final String value;
  final SynergeType type = SynergeType.place;

  PlaceSynerge(
    this.value,
  ) : super(value, SynergeType.place);
}

class ColorSynerge extends BaseSynerge {
  final String value;
  final SynergeType type = SynergeType.color;
  final String color;

  ColorSynerge(this.value, this.color) : super(value, SynergeType.color);
}

class StuffSynerge extends BaseSynerge {
  final String value;
  final SynergeType type = SynergeType.stuff;

  StuffSynerge(this.value) : super(value, SynergeType.stuff);
}
