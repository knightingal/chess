import 'dart:math';

import 'package:chess/discover_china/city_info.dart';
import 'package:chess/discover_china/game_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'city_card.dart';
import 'dice.dart';
import 'widget_static_data.dart';

class DiscoverApp extends StatelessWidget {
  const DiscoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    initCityList();
    initLineList();
    initCityCardInfoList();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(height / heightGridCount,
        width / (widthGridCount + consoleWidth + playerTabWidth));
    return MaterialApp(
      title: "Discover",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DiscoverPlayGroundWidget(gridSize: grid),
    );
  }
}

class CityNameWidget extends StatelessWidget {
  final double gridSize;
  final int x;
  final int y;
  final String name;

  const CityNameWidget({
    super.key,
    required this.gridSize,
    required this.x,
    required this.y,
    required this.name,
  });

  List<Widget> getPlayerWidgetList(List<int> playerList) {
    List<Widget> playerWidgetList = [];
    if (playerList.contains(0)) {
      playerWidgetList.add(
        Positioned(
            left: 0,
            top: 0,
            width: gridSize / 2,
            height: gridSize / 2,
            child: Container(
              color: Colors.red,
            )),
      );
    }
    if (playerList.contains(1)) {
      playerWidgetList.add(
        Positioned(
            left: gridSize / 2,
            top: 0,
            width: gridSize / 2,
            height: gridSize / 2,
            child: Container(
              color: Colors.blue,
            )),
      );
    }
    if (playerList.contains(2)) {
      playerWidgetList.add(
        Positioned(
            left: 0,
            top: gridSize / 2,
            width: gridSize / 2,
            height: gridSize / 2,
            child: Container(
              color: Colors.orange,
            )),
      );
    }
    if (playerList.contains(3)) {
      playerWidgetList.add(
        Positioned(
            left: gridSize / 2,
            top: gridSize / 2,
            width: gridSize / 2,
            height: gridSize / 2,
            child: Container(
              color: Colors.green,
            )),
      );
    }

    return playerWidgetList;
  }

  void goToCity(BuildContext context) {
    var game = Provider.of<GameModel>(context, listen: false);
    PlayerData playerData = game.playerDataList[game.currentPlayer()];
    var currentCity = playerData.currCity;
    var lineColor = findLine(currentCity, name);
    if (lineColor == Colors.black) {
      return;
    }
    if (game.checkAndUseTicket(lineColor)) {
      game.setPlayerCity(0, name);
    }
  }

  @override
  Widget build(BuildContext context) => Positioned(
        left: gridSize * x,
        top: gridSize * y,
        width: gridSize,
        height: gridSize,
        child: GestureDetector(
          onTap: () {
            goToCity(context);
          },
          child: Consumer<GameModel>(builder: (context, game, child) {
            List<PlayerData> playerList = game.playerDataList;
            var playerIdList = playerList
                .where((element) => element.currCity == name)
                .map((e) => e.playerId)
                .toList();
            return Stack(
              children: [
                ...getPlayerWidgetList(playerIdList),
                SizedBox(
                    width: gridSize,
                    height: gridSize,
                    // color: Colors.amber,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Text(
                        name,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: gridSize / 3,
                        ),
                      ),
                    ))
              ],
            );
          }),
        ),
      );
}

class DiscoverPlayGroundWidget extends StatelessWidget {
  final double gridSize;
  const DiscoverPlayGroundWidget({super.key, required this.gridSize});

  List<Widget> getCityWidgets() {
    return cityList.values
        .map(
          (e) => ChangeNotifierProvider(
              create: (context) => gameModel,
              child: CityNameWidget(
                gridSize: gridSize,
                x: e.x,
                y: e.y,
                name: e.cityName,
              )),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        SizedBox(
            width: gridSize * widthGridCount,
            height: gridSize * heightGridCount,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(
                      gridSize * widthGridCount, gridSize * heightGridCount),
                  painter: PlayGroundCustomPainter(gridSize: gridSize),
                ),
                ...getCityWidgets()
              ],
            )),
        PlayConsolePad(gridSize: gridSize),
        PlayerTabs(gridSize: gridSize),
      ],
    ));
  }
}

GameModel gameModel = GameModel(2);

class PlayerTabs extends StatelessWidget {
  final double gridSize;

  const PlayerTabs({super.key, required this.gridSize});

  List<PlayerTab> getTabs(double gridSize, double height, int playerCount) {
    var playerColors = [Colors.red, Colors.blue, Colors.orange, Colors.green];
    List<PlayerTab> playerTabs = [];
    for (int i = 0; i < playerCount; i++) {
      playerTabs.add(PlayerTab(
        playerIndex: i,
        gridSize: gridSize,
        tabHeight: height / playerCount,
        color: playerColors[i],
      ));
    }

    return playerTabs;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => gameModel,
      child: SizedBox(
        width: gridSize * playerTabWidth,
        height: gridSize * heightGridCount,
        child: Column(
          children: [...getTabs(gridSize, height, 2)],
        ),
      ),
    );
  }
}

class PlayerTab extends StatelessWidget {
  final double gridSize;
  final double tabHeight;
  final Color color;
  final int playerIndex;

  const PlayerTab(
      {super.key,
      required this.playerIndex,
      required this.gridSize,
      required this.tabHeight,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      Provider.of<GameModel>(context, listen: false).setTabPlayer(playerIndex);
    }, child: Consumer<GameModel>(
      builder: ((context, game, child) {
        var playIndexText =
            "$playerIndex${game.currentPlayer() == playerIndex ? "\u{2705}" : ""}";
        if (game.getTabPlayer() != playerIndex) {
          return Container(
            width: gridSize,
            height: tabHeight,
            color: Colors.white,
            child: Center(
              child: Text(
                playIndexText,
                style: TextStyle(color: color),
              ),
            ),
          );
        } else {
          return Container(
            width: gridSize,
            height: tabHeight,
            color: color,
            child: Center(
              child: Text(
                playIndexText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }),
    ));
  }
}

class PlayConsolePad extends StatelessWidget {
  final double gridSize;

  const PlayConsolePad({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * consoleWidth,
      height: gridSize * heightGridCount,
      color: Colors.blueGrey,
      child: ChangeNotifierProvider(
        create: (context) => gameModel,
        child: Column(
          children: [
            CityCardList(gridSize: gridSize),
            TicketList(gridSize: gridSize),
            DiceWidget(gridSize: gridSize),

            // city list
          ],
        ),
      ),
    );
  }
}

class TicketList extends StatefulWidget {
  final double gridSize;

  const TicketList({super.key, required this.gridSize});

  @override
  State<StatefulWidget> createState() {
    return TicketState();
  }
}

class TicketState extends State<TicketList> {
  @override
  Widget build(BuildContext context) {
    var gridSize = widget.gridSize;
    return Container(
      width: gridSize * 10,
      height: gridSize * 3,
      color: Colors.green,
      child: Consumer<GameModel>(builder: (context, game, child) {
        var ticketCount = game.playerDataList[game.getTabPlayer()].ticketCount;
        return Row(
          children: [
            SignleTicket(
              gridSize: gridSize,
              color: Colors.red,
              count: ticketCount[0],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.purple,
              count: ticketCount[1],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.blue,
              count: ticketCount[2],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.green,
              count: ticketCount[3],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.orange,
              count: ticketCount[4],
            ),
          ],
        );
      }),
    );
  }
}

class SignleTicket extends StatelessWidget {
  final double gridSize;
  final Color color;
  final int count;

  const SignleTicket(
      {super.key,
      required this.gridSize,
      required this.color,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 2,
      height: gridSize * 3,
      color: color,
      child: Center(
        child: Text(count.toString()),
      ),
    );
  }
}

class PlayGroundCustomPainter extends CustomPainter {
  final double gridSize;

  PlayGroundCustomPainter({required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    // var rect = Offset.zero & size;
    // canvas.drawRect(rect, Paint()..color = playgroundBackground);

    for (var element in lineList) {
      var city1 = cityList[element.cityName1];
      var city2 = cityList[element.cityName2];
      if (city1 != null && city2 != null) {
        canvas.drawLine(
            calOffset(city1.x, city1.y),
            calOffset(city2.x, city2.y),
            Paint()
              ..color = element.color
              ..strokeWidth = 4);
      }
    }
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
