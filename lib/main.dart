import 'dart:math';

import 'package:flutter/material.dart';

import 'chess/piece.dart';
import 'chess/playground.dart';
import 'chess/target_cursor.dart';

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
    canvas.drawRect(rect, Paint()..color = playgroundBackground);

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

class _ChessMainState extends State<ChessMain> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    chessPlayGround.getPieceList().forEach((element) {
      element.controller = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this);
      element.animation =
          CurvedAnimation(parent: element.controller, curve: Curves.linear)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {});
              }
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(height / heightGridCount, width / widthGridCount);
    var parseTargetWidgets = chessPlayGround
        .getParseTargetList()
        .map((e) => TargetCursor(gridSize: grid, x: e.x, y: e.y));
    var pieceWidgets = chessPlayGround
        .getPieceList()
        .map((e) => Piece(
              key: UniqueKey(),
              gridSize: grid,
              text: e.role.name1,
              x: e.x,
              y: e.y,
              diffX: e.diffX,
              diffY: e.diffY,
              player: e.player,
              selected: e.selected,
              listenable: e.animation,
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
        child: Stack(children: [
          PlayGroundWidget(gridSize: grid),
          ...pieceWidgets,
          ...parseTargetWidgets
        ]),
      ),
      floatingActionButton: TextButton(
        onPressed: () =>
            {chessPlayGround.getPieceList()[9].controller.forward()},
        child: const Text(
          "确定",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
