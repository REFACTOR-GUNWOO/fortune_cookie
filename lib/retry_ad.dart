import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RetryAd extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RetryAd> createState() => _RetryAdState();
}

const Map<String, String> UNIT_ID = {
  'ios': 'ca-app-pub-3940256099942544/5224354917',
  'android': 'ca-app-pub-3940256099942544/5224354917',
};

class _RetryAdState extends State<RetryAd> {
  int _counter = 0;
  bool _showTooltip = true;
  RewardedAd? _rewardedAd;
  void showRewardFullBanner(Function callback) async {
    await RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            callback();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          callback();
        },
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: const AdRequest(),
    )..load();

    return Scaffold(
        appBar: AppBar(),
        body: Container(
            height: 50.0,
            child: AdWidget(
              ad: banner,
            )));
  }
}
