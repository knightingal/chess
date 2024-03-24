import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:developer' as dev;

class GameModel extends ChangeNotifier {
  int dice1 = Random().nextInt(6);
  int dice2 = Random().nextInt(6);

  void setDice(int dice1, int dice2) {
    dev.log("setDice $dice1 $dice2");
    this.dice1 = dice1;
    this.dice2 = dice2;
    notifyListeners();
  }
}
