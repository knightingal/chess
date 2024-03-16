import 'dart:math';

import 'package:chess/discover_china/city_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../chess/playground.dart';

const heightGridCount = 14;
const widthGridCount = 14;
const consoleWidth = 10;

class DiscoverApp extends StatelessWidget {
  const DiscoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    initCityList();

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

class PlayConsolePad extends StatelessWidget {
  final double gridSize;

  const PlayConsolePad({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * consoleWidth,
      height: gridSize * heightGridCount,
      color: Colors.blueGrey,
      child: Column(
        children: [
          CityCardList(gridSize: gridSize),
          TicketList(gridSize: gridSize),
          DiceWidget(gridSize: gridSize)
          // city list
        ],
      ),
    );
  }
}

class CityCardList extends StatelessWidget {
  final double gridSize;

  const CityCardList({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 10,
      height: gridSize * 6,
      color: Colors.blue,
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
    );
  }
}

class DiceWidget extends StatelessWidget {
  final double gridSize;

  const DiceWidget({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 10,
      height: gridSize * 5,
      color: Colors.lightBlue,
      child: Row(
        children: [
          SingleDice(gridSize: gridSize, color: Colors.red),
          SingleDice(gridSize: gridSize, color: Colors.yellow),
        ],
      ),
    );
  }
}

class SingleDice extends StatelessWidget {
  final double gridSize;
  final Color color;

  const SingleDice({super.key, required this.gridSize, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 5,
      height: gridSize * 5,
      color: color,
    );
  }
}

class PlayGroundCustomPainter extends CustomPainter {
  final double gridSize;

  PlayGroundCustomPainter({required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = playgroundBackground);

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    for (var i = 0; i < heightGridCount; i++) {
      canvas.drawLine(calOffset(0, i), calOffset(widthGridCount - 1, i), paint);
    }
    for (var i = 0; i < widthGridCount; i++) {
      canvas.drawLine(
          calOffset(i, 0), calOffset(i, heightGridCount - 1), paint);
    }
    canvas.drawLine(calOffset(6, 4), calOffset(11, 6), paint);
    canvas.drawLine(calOffset(10, 5), calOffset(11, 6), paint);
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
