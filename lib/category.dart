import 'package:flutter/material.dart';

class Category {
  final String name;
  Category(this.name);
}

List<Category> getCategories() {
  return [
    Category("오늘의 운세 점수"),
    Category("사람운세"),
    Category("금전운세"),
    Category("사랑운세")
  ];
}
