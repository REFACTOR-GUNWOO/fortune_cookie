import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Synerge extends StatefulWidget {
  final SynergeType synergeType;
  final String fortuneCategory;
  const Synerge(
      {Key? key, required this.fortuneCategory, required this.synergeType})
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

  @override
  void initState() {
    super.initState();
    _loadSynergeInfo();
  }

  String _getEnableKey() {
    return "${widget.fortuneCategory}${widget.synergeType}/enbaled";
  }

  String _getSynergeValueKey() {
    return "${widget.fortuneCategory}/${widget.synergeType}/value";
  }

  _loadSynergeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enabled = (prefs.getBool(_getEnableKey()) ?? false);
      value = (prefs.getString(_getSynergeValueKey()));
    });
  }

  Future<void> _showMyDialog(BaseSynerge synerge) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 254, 249, 230),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text('시너지 ${getSynergeLabel(synerge.type)}'),
              getSynergeResult(synerge)
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSynergeOpenEffect() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Center(
              child: Container(
                  width: 200,
                  height: 200,
                  child: Lottie.asset("assets/lotties/firecrakers.json",
                      repeat: false)),
            ));
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  _setSynergeInfo(SynergeType type) async {
    // if (enabled) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await showRewardFullBanner(() {
      BaseSynerge synerge = getSynerge(type);
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
        });
        prefs.setString(_getSynergeValueKey(), synerge.value);
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

  Container getSynergeResult(BaseSynerge synerge) {
    if (synerge.type == SynergeType.color) {
      return Container(
          child: Stack(alignment: Alignment.center, children: [
        Positioned(
            top: 10,
            child: Container(
              width: 40,
              height: 30,
              color: Colors.pink,
            )),
        Text(value ?? "", style: TextStyle(fontSize: 18)),
      ]));
    }
    if (synerge.type == SynergeType.place) {
      return Container(
          child: Text(value ?? "", style: TextStyle(fontSize: 18)));
    }
    if (synerge.type == SynergeType.stuff) {
      return Container(
          child: Text(value ?? "", style: TextStyle(fontSize: 18)));
    }

    throw Error();
  }

  Container getSynergeResultWidget(SynergeType synergeType) {
    if (synergeType == SynergeType.color) {
      return Container(
          child: Stack(alignment: Alignment.center, children: [
        Positioned(
            top: 10,
            child: Container(
              width: 40,
              height: 30,
              color: Colors.pink,
            )),
        Text(value ?? "", style: TextStyle(fontSize: 18)),
      ]));
    }
    if (synergeType == SynergeType.place) {
      return Container(
          child: Text(value ?? "", style: TextStyle(fontSize: 18)));
    }
    if (synergeType == SynergeType.stuff) {
      return Container(
          child: Text(value ?? "", style: TextStyle(fontSize: 18)));
    }

    throw Error();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          child: value == null
              ? IconButton(
                  icon: _getSynergeImage(),
                  iconSize: 50,
                  onPressed: () async {
                    await _setSynergeInfo(widget.synergeType);
                  },
                )
              : getSynergeResultWidget(widget.synergeType),
        ),
        Text("시너지\n${getSynergeLabel(widget.synergeType)}",
            style: TextStyle(fontSize: 18)),
      ],
    ));
  }
}

/**
 * 여기서 각 시너지 랜덤으로 받도록
 */
BaseSynerge getSynerge(SynergeType synergeType) {
  if (synergeType == SynergeType.color) {
    return ColorSynerge("분홍색", "분홍");
  }
  if (synergeType == SynergeType.place) {
    return PlaceSynerge("영화관");
  }
  if (synergeType == SynergeType.stuff) {
    return StuffSynerge("포크");
  }

  throw Error();
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
