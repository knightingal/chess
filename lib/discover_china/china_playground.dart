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
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
