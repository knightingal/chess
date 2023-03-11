import 'dart:math';

import 'package:flutter/material.dart';

import 'playground.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChessMain(title: 'Flutter Demo Home Page'),
    );
  }
}

class Piece extends StatelessWidget {
  final double gridSize;
  final int x;
  final int y;
  final bool selected;
  final String text;
  final int player;
  const Piece(
      {super.key,
      required this.gridSize,
      required this.x,
      required this.y,
      required this.text,
      required this.player,
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(gridSize * x, gridSize * y, 0, 0),
      child: SizedBox(
        width: gridSize,
        height: gridSize,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(gridSize, gridSize),
              painter:
                  PieceCustomPainter(gridSize: gridSize, selected: selected),
            ),
            Center(
              child: Text(text,
                  style: TextStyle(
                      fontSize: gridSize / 1.5,
                      fontFamily: "Lishu",
                      color: player == 1 ? Colors.black : Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}

class PieceCustomPainter extends CustomPainter {
  final double gridSize;
  final bool selected;

  PieceCustomPainter({required this.gridSize, this.selected = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint paint1 = Paint()..color = Colors.brown;

    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint0);
    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint1);
    if (selected) {
      Rect rect = Rect.fromLTRB(0, 0, gridSize, gridSize);
      canvas.drawRect(
          rect,
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
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

class PlayGroundWidget extends StatelessWidget {
  final double gridSize;
  const PlayGroundWidget({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(gridSize * widthGridCount, gridSize * heightGridCount),
      painter: PlayGroundCustomPainter(gridSize: gridSize),
    );
  }
}

class PlayGroundCustomPainter extends CustomPainter {
  final double gridSize;

  PlayGroundCustomPainter({required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Colors.yellow);

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    canvas.drawLine(calOffset(0, 0), calOffset(widthGridCount - 1, 0), paint);
    canvas.drawLine(calOffset(0, heightGridCount - 1),
        calOffset(widthGridCount - 1, heightGridCount - 1), paint);

    canvas.drawLine(calOffset(0, 0), calOffset(0, heightGridCount - 1), paint);
    canvas.drawLine(calOffset(widthGridCount - 1, 0),
        calOffset(widthGridCount - 1, heightGridCount - 1), paint);

    for (var i = 1; i < widthGridCount - 1; i++) {
      canvas.drawLine(calOffset(i, 0), calOffset(i, 4), paint);
      canvas.drawLine(
          calOffset(i, 5), calOffset(i, heightGridCount - 1), paint);
    }
    for (var i = 1; i < heightGridCount - 1; i++) {
      canvas.drawLine(calOffset(0, i), calOffset(widthGridCount - 1, i), paint);
    }

    canvas.drawLine(calOffset(3, 0), calOffset(5, 2), paint);
    canvas.drawLine(calOffset(5, 0), calOffset(3, 2), paint);

    canvas.drawLine(calOffset(3, heightGridCount - 1),
        calOffset(5, heightGridCount - 3), paint);
    canvas.drawLine(calOffset(5, heightGridCount - 1),
        calOffset(3, heightGridCount - 3), paint);
  }

  Offset calOffset(int x, int y) {
    return Offset((x + 0.5) * gridSize, (y + 0.5) * gridSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChessMain extends StatefulWidget {
  const ChessMain({super.key, required this.title});

  final String title;

  @override
  State<ChessMain> createState() => _ChessMainState();
}

class _ChessMainState extends State<ChessMain> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(
        height / (heightGridCount + 2 * deadPadding), width / widthGridCount);
    var pieceWidgets = chessPlayGround
        .getPieceList()
        .map((e) => Piece(
              key: UniqueKey(),
              gridSize: grid,
              text: e.text,
              x: e.x,
              y: e.y,
              player: e.player,
              selected: e.selected,
            ))
        .toList();
    return Scaffold(
      body: GestureDetector(
        onTapDown: (e) {
          var x = e.globalPosition.dx ~/ grid;
          var y = e.globalPosition.dy ~/ grid;
          chessPlayGround.processEvent(x, y);
          setState(() {});
        },
        child: Stack(
            children: [PlayGroundWidget(gridSize: grid), ...pieceWidgets]),
      ),
      floatingActionButton: TextButton(
        onPressed: () => {},
        child: const Text(
          "确定",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
