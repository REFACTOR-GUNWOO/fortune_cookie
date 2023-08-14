import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const Map<String, String> UNIT_ID = {
  'ios': 'ca-app-pub-3940256099942544/5224354917',
  'android': 'ca-app-pub-3940256099942544/5224354917',
};

showRewardFullBanner(Function callback) async {
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
