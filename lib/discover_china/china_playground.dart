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

  const CityNameWidget(
      {super.key,
      required this.gridSize,
      required this.x,
      required this.y,
      required this.name});

  @override
  Widget build(BuildContext context) => Positioned(
      left: gridSize * x,
      top: gridSize * y,
      width: gridSize,
      height: gridSize,
      child: Container(
          color: Colors.amber,
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
          )));
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
                CityNameWidget(gridSize: gridSize, x: 6, y: 5, name: "北京"),
                CityNameWidget(gridSize: gridSize, x: 5, y: 5, name: "天津"),
                CityNameWidget(gridSize: gridSize, x: 4, y: 7, name: "呼和浩特"),
                CityNameWidget(gridSize: gridSize, x: 3, y: 10, name: "西双版纳"),
                CityNameWidget(gridSize: gridSize, x: 4, y: 10, name: "昆明"),
                CityNameWidget(gridSize: gridSize, x: 10, y: 5, name: "南京"),
                CityNameWidget(gridSize: gridSize, x: 11, y: 6, name: "上海"),
                CityNameWidget(gridSize: gridSize, x: 11, y: 7, name: "杭州"),
                CityNameWidget(gridSize: gridSize, x: 12, y: 7, name: "台北"),
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
    canvas.drawLine(calOffset(6, 5), calOffset(11, 6), paint);
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
