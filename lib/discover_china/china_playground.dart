import 'package:flutter/material.dart';

import '../chess/playground.dart';

// const pieceBackground = Colors.brown;
// const pieceBord = Colors.yellow;
// const playgroundBackground = Colors.yellow;
// const heightGridCount = 10;
// const widthGridCount = 9;

class DiscoverPlayGroundWidget extends StatelessWidget {
  final double gridSize;
  const DiscoverPlayGroundWidget({super.key, required this.gridSize});

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
