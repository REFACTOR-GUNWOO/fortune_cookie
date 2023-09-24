import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

const Map<String, String> UNIT_ID = {
  'ios': 'ca-app-pub-3222851958863442/2914457506',
  'android': 'ca-app-pub-3222851958863442/2020178237',
};

showRewardFullBanner(Function callback) async {
  await RewardedAd.load(
    adUnitId: kDebugMode
        ? "ca-app-pub-3940256099942544/5224354917"
        : Platform.isAndroid
            ? "ca-app-pub-3222851958863442/2020178237"
            : "ca-app-pub-3222851958863442/2914457506",
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
