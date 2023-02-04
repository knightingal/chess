import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const PlayGroundWidget()
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const heightGridCount = 10;
const widthGridCount = 9;

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
    canvas.drawRect(rect, Paint()..color = const Color(0xFF0099FF));

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class PieceInfo {
  int x;
  int y;
  bool selected;
  String text;
  int player;

  PieceInfo(
      {required this.x,
      required this.y,
      required this.text,
      required this.player,
      this.selected = false});
}

class _MyHomePageState extends State<MyHomePage> {
  List<PieceInfo> pieceList = [
    PieceInfo(x: 0, y: 0, text: "车", player: 1),
    PieceInfo(x: 1, y: 0, text: "马", player: 1),
    PieceInfo(x: 2, y: 0, text: "相", player: 1),
    PieceInfo(x: 3, y: 0, text: "仕", player: 1),
    PieceInfo(x: 4, y: 0, text: "帅", player: 1),
    PieceInfo(x: 5, y: 0, text: "仕", player: 1),
    PieceInfo(x: 6, y: 0, text: "相", player: 1),
    PieceInfo(x: 7, y: 0, text: "马", player: 1),
    PieceInfo(x: 8, y: 0, text: "车", player: 1),
    PieceInfo(x: 1, y: 2, text: "炮", player: 1),
    PieceInfo(x: 7, y: 2, text: "炮", player: 1),
    PieceInfo(x: 0, y: 3, text: "兵", player: 1),
    PieceInfo(x: 2, y: 3, text: "兵", player: 1),
    PieceInfo(x: 4, y: 3, text: "兵", player: 1),
    PieceInfo(x: 6, y: 3, text: "兵", player: 1),
    PieceInfo(x: 8, y: 3, text: "兵", player: 1),
    //
    PieceInfo(x: 0, y: 9, text: "车", player: 2),
    PieceInfo(x: 1, y: 9, text: "马", player: 2),
    PieceInfo(x: 2, y: 9, text: "相", player: 2),
    PieceInfo(x: 3, y: 9, text: "仕", player: 2),
    PieceInfo(x: 4, y: 9, text: "帅", player: 2),
    PieceInfo(x: 5, y: 9, text: "仕", player: 2),
    PieceInfo(x: 6, y: 9, text: "相", player: 2),
    PieceInfo(x: 7, y: 9, text: "马", player: 2),
    PieceInfo(x: 8, y: 9, text: "车", player: 2),
    PieceInfo(x: 1, y: 7, text: "炮", player: 2),
    PieceInfo(x: 7, y: 7, text: "炮", player: 2),
    PieceInfo(x: 0, y: 6, text: "兵", player: 2),
    PieceInfo(x: 2, y: 6, text: "兵", player: 2),
    PieceInfo(x: 4, y: 6, text: "兵", player: 2),
    PieceInfo(x: 6, y: 6, text: "兵", player: 2),
    PieceInfo(x: 8, y: 6, text: "兵", player: 2),
  ];

  PieceInfo? selected = null;

  int pos = 0;

  void _incrementCounter() {
    setState(() {
      pos++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(height / heightGridCount, width / widthGridCount);
    var pieceWidgets = pieceList
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
          if (selected != null) {
            var target = pieceList.firstWhere(
                (element) => element.x == x && element.y == y,
                orElse: () => PieceInfo(x: -1, y: -1, text: "", player: -1));
            if (target.x >= 0) {
              if (target.player != selected?.player) {
                pieceList.remove(target);
                selected?.x = x;
                selected?.y = y;
                selected?.selected = false;
                selected = null;
              } else {
                selected?.selected = false;
                target.selected = true;
                selected = target;
              }
            } else {
              selected?.x = x;
              selected?.y = y;
              selected?.selected = false;
              selected = null;
            }
          } else {
            for (var element in pieceList) {
              if (element.x == x && element.y == y) {
                element.selected = true;
                selected = element;
              } else {
                element.selected = false;
              }
            }
          }

          setState(() {});
        },
        child: Stack(
            children: [PlayGroundWidget(gridSize: grid), ...pieceWidgets]),
      ),
      floatingActionButton: TextButton(
        onPressed: _incrementCounter,
        child: const Text(
          "确定",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
