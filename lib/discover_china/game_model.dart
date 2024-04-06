import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

import 'city_info.dart';

List<Color> diceColors = [
  Colors.red,
  Colors.purple,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.white,
  Colors.grey,
];

class GameModel extends ChangeNotifier {
  int dice1 = Random().nextInt(6);
  int dice2 = Random().nextInt(6);

  bool dice1Used = false;
  bool dice2Used = false;

  int playerTurn = 0;

  int currentPlayer() {
    return playerTurn % playerDataList.length;
  }

  int tabPlayer = 0;

  void setTabPlayer(int tabPlayer) {
    this.tabPlayer = tabPlayer;
    notifyListeners();
  }

  int getTabPlayer() {
    return tabPlayer;
  }

  List<PlayerData> playerDataList = [];

  int _colorToIndex(Color color) {
    return diceColors.indexOf(color);
  }

  bool checkAndUseTicket(Color color) {
    var ticketCount = playerDataList[currentPlayer()].ticketCount;
    int colorIndex = _colorToIndex(color);
    if (dice1 == colorIndex && !dice1Used) {
      // dice1 = 6;
      dice1Used = true;
      notifyListeners();
      return true;
    }
    if (dice2 == colorIndex && !dice2Used) {
      dice2Used = true;
      notifyListeners();
      return true;
    }
    if (dice1 == 5 && !dice1Used) {
      dice1Used = true;
      notifyListeners();
      return true;
    }
    if (dice2 == 5 && !dice2Used) {
      dice2Used = true;
      notifyListeners();
      return true;
    }
    if (ticketCount[colorIndex] > 0) {
      ticketCount[colorIndex] -= 1;
      notifyListeners();
      return true;
    }
    return false;
  }

  GameModel(int playerCount) {
    for (int i = 0; i < playerCount; i++) {
      PlayerData playerData = PlayerData(playerId: i);
      playerData.cityCardList = getPlayerCityCards();
      playerDataList.add(playerData);
    }
  }

  void setPlayerCity(int player, String city) {
    playerDataList[currentPlayer()].currCity = city;
    var cityReachedIt = playerDataList[currentPlayer()]
        .cityCardList
        .where((element) => element.cityName == city);
    if (cityReachedIt.isNotEmpty) {
      var cityReached = cityReachedIt.first;
      cityReached.cityName = "${cityReached.cityName}\u{2705}";
    }
    notifyListeners();
  }

  void setDice(int dice1, int dice2) {
    dev.log("setDice $dice1 $dice2");
    this.dice1 = dice1;
    this.dice2 = dice2;
    dice1Used = false;
    dice2Used = false;
    playerTurn += 1;
    tabPlayer = currentPlayer();
    notifyListeners();
  }

  void storeTicket() {
    if (dice1 < 5 && !dice1Used) {
      playerDataList[currentPlayer()].ticketCount[dice1] =
          playerDataList[currentPlayer()].ticketCount[dice1] + 1;
    }
    if (dice2 < 5 && !dice2Used) {
      playerDataList[currentPlayer()].ticketCount[dice2] =
          playerDataList[currentPlayer()].ticketCount[dice2] + 1;
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

GameModel gameModel = GameModel(2);
