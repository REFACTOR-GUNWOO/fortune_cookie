import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    print(status);
    setState(() {
      _notificationEnabled = status.isGranted;
    });
  }

  Future<void> _toggleNotificationPermission() async {
    if (_notificationEnabled) {
      await openAppSettings();
    } else {
      // Redirect the user to the app settings to enable notifications
      await openAppSettings();
    }
    _checkNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/setting_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   title: Text('Notification Settings'),
            // ),
            floatingActionButton: Stack(children: [
              Positioned(
                  top: 100,
                  right: 10,
                  child: IconButton(
                    icon: SvgPicture.asset("assets/icons/setting_close.svg"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ]),
            body: Container(
              margin: EdgeInsets.only(top: 250),
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/lotties/cookie/today/a.json',
                      animate: false, repeat: false, width: 120),
                  Text(
                    '포춘이는 하루의 메세지를 담아\n날마다 맛있는 포춘쿠키로 태어나요',
                    style: TextStyle(fontSize: 18, color: Color(0xFF5E5C55)),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFFFEF9E6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "포춘쿠키 알림",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF7F7E7A)),
                                )),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "쿠키가 구워지면 알려드릴게요!",
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xFF33322E)),
                              ),
                            ),
                          ]),
                          Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.black,
                            value: _notificationEnabled,
                            onChanged: (value) {
                              // if (_notificationEnabled) {
                              openAppSettings();
                              // }
                            },
                          ),
                        ],
                      )),
                  // Container(
                  //   margin: EdgeInsets.only(left: 20, right: 20, top: 12),
                  //   padding: EdgeInsets.all(24),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     color: Color(0xFFFEF9E6),
                  //   ),
                  //   child: const Column(children: [
                  //     Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "더 나은 포춘이가 될 수 있도록",
                  //         style:
                  //             TextStyle(fontSize: 16, color: Color(0xFF7F7E7A)),
                  //       ),
                  //     ),
                  //     Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "앱 후기를 알려주세요",
                  //         style:
                  //             TextStyle(fontSize: 20, color: Color(0xFF33322E)),
                  //       ),
                  //     ),
                  //   ]),
                  // ),
                ],
              ),
            )));
  }
}
