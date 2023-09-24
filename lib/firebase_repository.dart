import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fortune_cookie_flutter/category.dart';
import 'package:fortune_cookie_flutter/synerge.dart';

class FortuneRepository {
  Future<String> getFortune(Category category) async {
    FirebaseDatabase _realtime = FirebaseDatabase.instance;
    List<Object?> fortuneList =
        (await _realtime.ref("fortune").child(category.code).get()).value
            as List<Object?>;
    final _random = new Random();
    int randomIndex = _random.nextInt(fortuneList.length);
    String fortune = fortuneList[randomIndex].toString();
    return fortune;
  }
}

class SynergeRepository {
  Future<BaseSynerge> getSynerge(SynergeType synergeType) async {
    FirebaseDatabase _realtime = FirebaseDatabase.instance;
    List<Object?> synergeList = (await _realtime
            .ref("fortune")
            .child("synergy")
            .child(synergeType.name)
            .get())
        .value as List<Object?>;
    final _random = new Random();
    int randomIndex = _random.nextInt(synergeList.length);
    Object synerge = synergeList[randomIndex]!;

    if (synergeType == SynergeType.color) {
      return ColorSynerge(
          (Map<String, String>.from(synerge as Map<Object?, Object?>))["name"]!,
          (Map<String, String>.from(
              synerge as Map<Object?, Object?>))["hexCode"]!);
    }
    if (synergeType == SynergeType.place) {
      return PlaceSynerge(synerge as String);
    }
    if (synergeType == SynergeType.stuff) {
      return StuffSynerge(synerge as String);
    }

    throw Error();
  }
}

class ColorSynergeDto {
  late String name;
  late String hexCode;
}
