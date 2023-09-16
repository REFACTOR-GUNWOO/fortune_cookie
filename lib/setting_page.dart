import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
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
            floatingActionButton: Container(child: Align()),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // VisibilityDetector(
                  //   onVisibilityChanged: (visibilityInfo) {
                  //     _checkNotificationPermission();
                  //   },
                  //   key: Key("setting"),
                  //   child: Text('Visibility detector example'),
                  // ),
                  Text(
                    'Local Notifications are ${_notificationEnabled ? 'enabled' : 'disabled'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleNotificationPermission,
                    child: Text(
                      _notificationEnabled
                          ? 'Disable Notifications'
                          : 'Enable Notifications',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )));
  }
}
