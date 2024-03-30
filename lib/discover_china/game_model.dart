import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

import 'city_info.dart';

class GameModel extends ChangeNotifier {
  int dice1 = Random().nextInt(6);
  int dice2 = Random().nextInt(6);

  List<PlayerData> playerDataList = [];

  GameModel(int playerCount) {
    for (int i = 0; i < playerCount; i++) {
      PlayerData playerData = PlayerData(playerId: i);
      playerData.cityCardList = getPlayerCityCards();
      playerDataList.add(playerData);
    }
  }

  void setDice(int dice1, int dice2) {
    dev.log("setDice $dice1 $dice2");
    this.dice1 = dice1;
    this.dice2 = dice2;
    notifyListeners();
  }
}

class PlayerData {
  final int playerId;
  String currCity = "北京";

  List<CityCardInfo> cityCardList = [];

  int ticketCountRed = 0;
  int ticketCountPurple = 0;
  int ticketCountBlue = 0;
  int ticketCountGreen = 0;
  int ticketCountYellow = 0;

  PlayerData({required this.playerId});
}
