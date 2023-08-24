import 'package:flutter/cupertino.dart';
import 'package:fortune_cookie_flutter/category.dart';

class CookieOpenController extends ValueNotifier<List<Category>> {
  CookieOpenController() : super([]);

  void setCookieOpenState(Category category) {
    List<Category> newList = List.from(value);
    newList.add(category);
    value = newList;
  }
}
