import 'dart:math';

import 'package:chess/discover_china/city_info.dart';
import 'package:chess/discover_china/game_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dice.dart';

const heightGridCount = 14;
const widthGridCount = 14;
const consoleWidth = 10;

class DiscoverApp extends StatelessWidget {
  const DiscoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    initCityList();
    initLineList();
    initCityCardInfoList();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid =
        min(height / heightGridCount, width / (widthGridCount + consoleWidth));
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
  final List<int> playerList;

  const CityNameWidget(
      {super.key,
      required this.gridSize,
      required this.x,
      required this.y,
      required this.name,
      required this.playerList});

  List<Widget> getPlayerWidgetList() {
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

  @override
  Widget build(BuildContext context) => Positioned(
      left: gridSize * x,
      top: gridSize * y,
      width: gridSize,
      height: gridSize,
      child: Stack(
        children: [
          ...getPlayerWidgetList(),
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
      ));
}

class DiscoverPlayGroundWidget extends StatelessWidget {
  final double gridSize;
  const DiscoverPlayGroundWidget({super.key, required this.gridSize});

  List<Widget> getCityWidgets() {
    return cityList.values
        .map((e) => CityNameWidget(
            gridSize: gridSize,
            x: e.x,
            y: e.y,
            name: e.cityName,
            playerList: []))
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
      ],
    ));
  }
}

GameModel gameModel = GameModel(2);

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

class CityCardList extends StatefulWidget {
  final double gridSize;

  const CityCardList({super.key, required this.gridSize});

  @override
  State<StatefulWidget> createState() {
    return CityCardState();
  }
}

class CityCardState extends State<CityCardList> {
  @override
  void initState() {
    super.initState();
  }

  static const List<Color> ticketColor = [
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    var gridSize = widget.gridSize;
    return Container(
      width: gridSize * 10,
      height: gridSize * 6,
      color: Colors.grey,
      child: Consumer<GameModel>(
        builder: (context, game, child) {
          var playerCityCard = game.playerDataList[0].cityCardList;
          int row1Max = min(5, playerCityCard.length);

          List<CityCard> row1 = playerCityCard.sublist(0, row1Max).map((e) {
            return CityCard(
                gridSize: gridSize,
                color: ticketColor[e.ticket - 1],
                cityName: e.cityName);
          }).toList();

          List<CityCard> row2 = [];
          if (playerCityCard.length > 5) {
            row2 = playerCityCard.sublist(5, playerCityCard.length).map((e) {
              return CityCard(
                  gridSize: gridSize,
                  color: ticketColor[e.ticket - 1],
                  cityName: e.cityName);
            }).toList();
          }

          return Column(
            children: [
              Row(
                children: [...row1],
              ),
              Row(
                children: [...row2],
              )
            ],
          );
        },
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final double gridSize;
  final Color color;
  final String cityName;

  const CityCard({
    super.key,
    required this.gridSize,
    required this.color,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 2,
      height: gridSize * 3,
      color: color,
      child: Center(
        child: Text(cityName),
      ),
    );
  }
}

class TicketList extends StatelessWidget {
  final double gridSize;

  const TicketList({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 10,
      height: gridSize * 3,
      color: Colors.green,
      child: Row(
        children: [
          SignleTicket(gridSize: gridSize, color: Colors.red),
          SignleTicket(gridSize: gridSize, color: Colors.purple),
          SignleTicket(gridSize: gridSize, color: Colors.blue),
          SignleTicket(gridSize: gridSize, color: Colors.green),
          SignleTicket(gridSize: gridSize, color: Colors.yellow),
        ],
      ),
    );
  }
}

class SignleTicket extends StatelessWidget {
  final double gridSize;
  final Color color;

  const SignleTicket({super.key, required this.gridSize, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 2,
      height: gridSize * 3,
      color: color,
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

    // for (var i = 0; i < heightGridCount; i++) {
    //   canvas.drawLine(calOffset(0, i), calOffset(widthGridCount - 1, i), paint);
    // }
    // for (var i = 0; i < widthGridCount; i++) {
    //   canvas.drawLine(
    //       calOffset(i, 0), calOffset(i, heightGridCount - 1), paint);
    // }
    // canvas.drawLine(calOffset(6, 4), calOffset(11, 6), paint);
    // canvas.drawLine(calOffset(10, 5), calOffset(11, 6), paint);
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
