import 'package:flutter/cupertino.dart';
import 'package:fortune_cookie_flutter/category.dart';

class SynergeLoadingController extends ValueNotifier<bool> {
  SynergeLoadingController() : super(false);

  void setSynergeLoadingState(bool isLoading) {
    print("setSynergeLoadingState $isLoading");
    value = isLoading;
  }
}
