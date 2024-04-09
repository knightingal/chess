import 'dart:math';

import 'package:chess/discover_china/city_info.dart';
import 'package:chess/discover_china/game_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'city_card.dart';
import 'dice.dart';
import 'player_tab.dart';
import 'ticket.dart';
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
      home: ChangeNotifierProvider(
        create: (context) => gameModel,
        child: DiscoverPlayGroundWidget(gridSize: grid),
      ),
    );
  }
}

class PlayerPiece extends StatelessWidget {
  final double size;
  final Color color;
  final double gridSize;
  final int x;
  final int y;
  final int playerIndex;

  const PlayerPiece(
      {super.key,
      required this.playerIndex,
      required this.size,
      required this.color,
      required this.gridSize,
      required this.x,
      required this.y});
  @override
  Widget build(BuildContext context) {
    double left = switch (playerIndex) {
      0 || 2 => gridSize * x,
      1 || 3 => gridSize * x + gridSize / 2,
      _ => 0
    };
    double top = switch (playerIndex) {
      0 || 1 => gridSize * y,
      2 || 3 => gridSize * y + gridSize / 2,
      _ => 0
    };
    Color color = switch (playerIndex) {
      0 => Colors.red,
      1 => Colors.blue,
      2 => Colors.orange,
      3 => Colors.green,
      _ => Colors.black
    };

    return Positioned(
      left: left,
      top: top,
      width: gridSize / 2,
      height: gridSize / 2,
      child: CustomPaint(
          size: Size(size, size), painter: PlayerPiecePainter(color: color)),
    );
  }
}

class PlayerPiecePainter extends CustomPainter {
  final Color color;

  PlayerPiecePainter({super.repaint, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
            // List<PlayerData> playerList = game.playerDataList;
            // var playerIdList = playerList
            //     .where((element) => element.currCity == name)
            //     .map((e) => e.playerId)
            //     .toList();
            return Stack(
              children: [
                // ...getPlayerWidgetList(playerIdList),
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

  List<Widget> getPlayerWidgetList(List<PlayerData> playerDataList) {
    return playerDataList.map((playerData) {
      var cityName = playerData.currCity;
      int x = cityList[cityName]!.x;
      int y = cityList[cityName]!.y;
      return PlayerPiece(
          playerIndex: playerData.playerId,
          size: gridSize / 2,
          color: Colors.black,
          gridSize: gridSize,
          x: x,
          y: y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(builder: (context, game, child) {
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
                  ...getPlayerWidgetList(game.playerDataList),
                  ...getCityWidgets()
                ],
              )),
          PlayConsolePad(gridSize: gridSize),
          PlayerTabs(gridSize: gridSize),
        ],
      ));
    });
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
