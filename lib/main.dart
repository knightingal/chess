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
  const Piece(
      {super.key, required this.gridSize, required this.x, required this.y});

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
              painter: PieceCustomPainter(gridSize: gridSize),
            ),
            Center(
              child: Text("帅",
                  style:
                      TextStyle(fontSize: gridSize / 1.5, fontFamily: "Lishu")),
            )
          ],
        ),
      ),
    );
  }
}

class PieceCustomPainter extends CustomPainter {
  final double gridSize;

  PieceCustomPainter({required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint paint1 = Paint()..color = Colors.brown;

    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint0);
    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint1);
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
  late int x;
  late int y;
  PieceInfo({required this.x, required this.y});
}

class _MyHomePageState extends State<MyHomePage> {
  List<PieceInfo> pieceList = [];

  int pos = 0;

  void _incrementCounter() {
    setState(() {
      pieceList.add(PieceInfo(x: pos, y: pos));
      pos++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var grid = min(height / heightGridCount, width / widthGridCount);
    return Scaffold(
      body: Stack(children: [
        PlayGroundWidget(gridSize: grid),
        ...pieceList.map((e) => Piece(gridSize: grid, x: e.x, y: e.y))
      ]),
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
