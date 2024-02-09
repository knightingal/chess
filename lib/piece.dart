import 'package:flutter/material.dart';

import 'playground.dart';

class Piece extends AnimatedWidget {
  final double gridSize;
  final int x;
  final int y;
  final int diffX;
  final int diffY;
  final bool selected;
  final String text;
  final int player;
  Piece(
      {super.key,
      required this.gridSize,
      required this.x,
      required this.y,
      required this.diffX,
      required this.diffY,
      required this.text,
      required this.player,
      this.selected = false,
      required super.listenable}) {
    _sizeTween = Tween<double>(begin: 0, end: gridSize);
  }

  late final Tween<double> _sizeTween;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      padding: EdgeInsets.fromLTRB(
          gridSize * x + _sizeTween.evaluate(animation) * diffX,
          gridSize * y + _sizeTween.evaluate(animation) * diffY,
          0,
          0),
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
                      color: player == 1 ? player1Color : player0Color)),
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
      ..color = pieceBord
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Paint paint1 = Paint()..color = pieceBackground;

    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint0);
    canvas.drawCircle(calOffset(0, 0), gridSize / 2.2, paint1);
    if (selected) {
      Rect rect = Rect.fromLTRB(0, 0, gridSize, gridSize);
      canvas.drawRect(
          rect,
          Paint()
            ..color = selectBordColor
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
