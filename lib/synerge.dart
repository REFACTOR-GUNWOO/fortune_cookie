import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_cookie_flutter/retry_ad.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Synerge extends StatefulWidget {
  final String synergeType;
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

  @override
  void initState() {
    super.initState();
    _loadSynergeInfo();
  }

  String _getEnableKey() {
    return "${widget.fortuneCategory}${widget.synergeType}enbaled";
  }

  _loadSynergeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enabled = (prefs.getBool(_getEnableKey()) ?? false);
    });
  }

  _setSynergeInfo() async {
    // if (enabled) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await showRewardFullBanner(() {
      if (enabled) {
        setState(() {
          enabled = false;
        });
      } else {
        setState(() {
          enabled = true;
        });
      }
      prefs.setBool(_getEnableKey(), enabled);
    });
  }

  SvgPicture _getSynergeImage() {
    if (enabled) {
      return SvgPicture.asset("assets/images/synerge_enabled.svg");
    } else {
      return SvgPicture.asset("assets/images/synerge_disabled.svg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        IconButton(
          icon: _getSynergeImage(),
          iconSize: 50,
          onPressed: () async {
            await _setSynergeInfo();
          },
        ),
        Text("시너지 ${widget.synergeType}"),
      ],
    ));
  }
}
