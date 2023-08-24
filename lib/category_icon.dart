import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fortune_cookie_flutter/category.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FortuneCategoryIcon extends StatefulWidget {
  final Category fortuneCategory;
  final bool checked;
  final bool alwaysOpen;
  const FortuneCategoryIcon(
      {Key? key,
      required this.fortuneCategory,
      required this.checked,
      required this.alwaysOpen})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<FortuneCategoryIcon> createState() => _FortuneCategoryIconState();
}

class _FortuneCategoryIconState extends State<FortuneCategoryIcon>
    with SingleTickerProviderStateMixin {
  late bool _opened = false;

  String _getOpenedKey() {
    return "${widget.fortuneCategory.name}.fortueCookie.opened";
  }

  _loadFortuneCookieInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _opened = _prefs.getBool(_getOpenedKey()) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFortuneCookieInfo();
  }

  Widget _getCategoryImage() {
    if (_opened || widget.alwaysOpen) {
      if (widget.checked) {
        return Stack(children: [
          SvgPicture.asset(widget.fortuneCategory.enabledIconPath),
          Positioned(
              left: 0,
              right: 0,
              top: 5,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                    "assets/images/category/selected_mark.svg"),
              ))
        ]);
      } else {
        return SvgPicture.asset(widget.fortuneCategory.enabledIconPath);
      }
    } else {
      if (widget.checked) {
        return Stack(children: [
          SvgPicture.asset(widget.fortuneCategory.disabledIconPath),
          Positioned(
              left: 0,
              right: 0,
              top: 5,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                    "assets/images/category/selected_mark.svg"),
              ))
        ]);
      } else {
        return SvgPicture.asset(widget.fortuneCategory.disabledIconPath);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _getCategoryImage());
  }
}
