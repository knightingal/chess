import 'dart:developer' as dev;
import 'dart:math';

import 'package:chess/discover_china/script/computer_player.dart';
import 'package:chess/discover_china/script/discover_graph.dart';
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

  String? pathSrc;
  String? pathDest;

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
    if (ticketCount[colorIndex] > 0) {
      ticketCount[colorIndex] -= 1;
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
    return false;
  }

  GameModel(int playerCount) {
    for (int i = 0; i < playerCount; i++) {
      PlayerData playerData = PlayerData(playerId: i, robote: i != 0);
      playerData.cityCardList = getPlayerCityCards(playerData.robote);
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

  void playerGo(int player) {
    PlayerData playerData = playerDataList[player];
    if (!playerData.robote) {
      return;
    }

    String currCity = playerData.currCity;
    String targetCity = playerData.cityCardList[0].cityName;
    NextStepNode? nextNode = nextMatrix.getNodeById(currCity, targetCity);
    String nextCity = nextNode!.nextNode.first.nodeId;

    var lineColor = findLine(currCity, nextCity);
    if (lineColor == Colors.black) {
      return;
    }
    if (checkAndUseTicket(lineColor)) {
      setPlayerCity(player, nextCity);
    }
  }

  Set<LineInfo> markedLine = {};

  void setPath(String city) {
    if (pathSrc == null) {
      pathSrc = city;
    } else if (pathDest == null) {
      pathDest = city;
      Set<LineInfo> allPath = calAllPath(pathSrc!, pathDest!);
      markedLine = allPath;
    } else {
      pathSrc = city;
      pathDest = null;
      markedLine = {};
    }
    notifyListeners();
  }

  void _setDice(int dice1, int dice2) {
    dev.log("setDice $dice1 $dice2");
    this.dice1 = dice1;
    this.dice2 = dice2;
    dice1Used = false;
    dice2Used = false;
  }

  void nextTurn() {
    _storeTicket();
    int dice1 = Random().nextInt(6);
    int dice2 = Random().nextInt(6);
    _setDice(dice1, dice2);
    playerTurn += 1;
    tabPlayer = currentPlayer();
    notifyListeners();

    if (playerDataList[currentPlayer()].robote) {
      playerGo(currentPlayer());
      nextTurn();
    }
  }

  void _storeTicket() {
    if (dice1 < 5 && !dice1Used) {
      playerDataList[currentPlayer()].ticketCount[dice1] =
          playerDataList[currentPlayer()].ticketCount[dice1] + 1;
    }
    if (dice2 < 5 && !dice2Used) {
      playerDataList[currentPlayer()].ticketCount[dice2] =
          playerDataList[currentPlayer()].ticketCount[dice2] + 1;
    }
  }

  void setSelectCard(String cityName) {
    if (playerDataList[tabPlayer].selectedCard == cityName) {
      playerDataList[tabPlayer].selectedCard = "";
    } else {
      if (playerDataList[tabPlayer].selectedCard != "") {
        int toIndex = playerDataList[tabPlayer]
            .cityCardList
            .indexWhere((element) => element.cityName == cityName);
        var fromCard = playerDataList[tabPlayer].cityCardList.firstWhere(
            (element) =>
                element.cityName == playerDataList[tabPlayer].selectedCard);
        playerDataList[tabPlayer].cityCardList.remove(fromCard);
        playerDataList[tabPlayer].cityCardList.insert(toIndex, fromCard);
        playerDataList[tabPlayer].selectedCard = "";
      } else {
        playerDataList[tabPlayer].selectedCard = cityName;
      }
    }
    notifyListeners();
  }
}

class PlayerData {
  final int playerId;
  String currCity = "北京";

  String selectedCard = "";

  bool robote;

  List<CityCardInfo> cityCardList = [];

  List<int> ticketCount = [0, 0, 0, 0, 0];

  PlayerData({required this.playerId, required this.robote});
}

GameModel gameModel = GameModel(2);
