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

  void setPlayerCity(int player, String city) {
    playerDataList[player].currCity = city;
    notifyListeners();
  }

  void setDice(int dice1, int dice2) {
    dev.log("setDice $dice1 $dice2");
    this.dice1 = dice1;
    this.dice2 = dice2;
    notifyListeners();
  }

  void storeTicket() {
    if (dice1 < 5) {
      playerDataList[0].ticketCount[dice1] =
          playerDataList[0].ticketCount[dice1] + 1;
    }
    if (dice2 < 5) {
      playerDataList[0].ticketCount[dice2] =
          playerDataList[0].ticketCount[dice2] + 1;
    }
    notifyListeners();
  }
}

class PlayerData {
  final int playerId;
  String currCity = "北京";

  List<CityCardInfo> cityCardList = [];

  List<int> ticketCount = [0, 0, 0, 0, 0];

  PlayerData({required this.playerId});
}
