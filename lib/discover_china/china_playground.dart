import 'dart:math';

import 'package:flutter/material.dart';

import '../chess/playground.dart';

const heightGridCount = 14;
const widthGridCount = 14;

class DiscoverApp extends StatelessWidget {
  const DiscoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(height / heightGridCount, width / widthGridCount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: gridSize * widthGridCount,
            height: gridSize * heightGridCount,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(
                      gridSize * widthGridCount, gridSize * heightGridCount),
                  painter: PlayGroundCustomPainter(gridSize: gridSize),
                ),
                CityNameWidget(
                  gridSize: gridSize,
                  x: 6,
                  y: 4,
                  name: "北京",
                  playerList: [0, 2, 1, 3],
                ),
                CityNameWidget(
                  gridSize: gridSize,
                  x: 5,
                  y: 5,
                  name: "天津",
                  playerList: [],
                ),
                CityNameWidget(
                  gridSize: gridSize,
                  x: 4,
                  y: 7,
                  name: "呼和浩特",
                  playerList: [],
                ),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 3,
                    y: 10,
                    name: "西双版纳",
                    playerList: []),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 4,
                    y: 10,
                    name: "昆明",
                    playerList: []),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 10,
                    y: 5,
                    name: "南京",
                    playerList: []),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 11,
                    y: 6,
                    name: "上海",
                    playerList: []),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 11,
                    y: 7,
                    name: "杭州",
                    playerList: []),
                CityNameWidget(
                    gridSize: gridSize,
                    x: 12,
                    y: 7,
                    name: "台北",
                    playerList: []),
              ],
            )));
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
