import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final String name;
  final String tabName;
  final String code;
  final String enabledIconPath;
  final String disabledIconPath;
  Category(this.name, this.tabName, this.code, this.enabledIconPath,
      this.disabledIconPath);
}

List<Category> getCategories() {
  return [
    Category(
        "오늘의 운세",
        "오늘의\n운세",
        "today",
        "assets/images/category/enabled/today.svg",
        "assets/images/category/disabled/today.svg"),
    Category(
        "사람운세",
        "사람운세",
        "people",
        "assets/images/category/enabled/people.svg",
        "assets/images/category/disabled/people.svg"),
    Category(
        "금전운세",
        "금전운세",
        "money",
        "assets/images/category/enabled/money.svg",
        "assets/images/category/disabled/money.svg"),
    Category("사랑운세", "사랑운세", "love", "assets/images/category/enabled/love.svg",
        "assets/images/category/disabled/love.svg"),
  ];
}
