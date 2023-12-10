import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:fortune_cookie_flutter/category.dart';

class PhraseRepository {
  Future<BasePhrase> getPhrase(Category category) async {
    FirebaseDatabase _realtime = FirebaseDatabase.instance;
    List<Object?> phraseList =
        (await _realtime.ref("phrase").child(category.code).get()).value
            as List<Object?>;
    final _random = new Random();
    int randomIndex = _random.nextInt(phraseList.length);
    Map<dynamic, dynamic> phrase =
        phraseList[randomIndex]! as Map<dynamic, dynamic>;

    return BasePhrase(phrase["phraseString"], phrase["author"]);
  }
}

enum PhraseType { place, color, stuff }

class BasePhrase {
  final String phraseString;
  final String author;

  BasePhrase(this.phraseString, this.author);
}
