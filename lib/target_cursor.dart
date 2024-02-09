import 'package:flutter/material.dart';

import 'playground.dart';

class TargetCursor extends StatelessWidget {
  const TargetCursor({
    super.key,
    required this.gridSize,
    required this.x,
    required this.y,
  });

  final double gridSize;
  final int x;
  final int y;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(gridSize * x, gridSize * y, 0, 0),
      child: SizedBox(
        width: gridSize,
        height: gridSize,
        child: CustomPaint(
          size: Size(gridSize, gridSize),
          painter: TargetCursorPainter(gridSize),
        ),
      ),
    );
  }
}

class TargetCursorPainter extends CustomPainter {
  final double gridSize;

  TargetCursorPainter(this.gridSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = targetBordColor
      ..strokeWidth = 2;
    var lineLen = gridSize / 4;
    var bonderLen = gridSize / 8;

    canvas.drawLine(Offset(0 + bonderLen, 0 + bonderLen),
        Offset(lineLen, 0 + bonderLen), paint);
    canvas.drawLine(Offset(0 + bonderLen, 0 + bonderLen),
        Offset(0 + bonderLen, lineLen), paint);

    canvas.drawLine(Offset(gridSize - bonderLen, 0 + bonderLen),
        Offset(gridSize - lineLen, 0 + bonderLen), paint);
    canvas.drawLine(Offset(gridSize - bonderLen, 0 + bonderLen),
        Offset(gridSize - bonderLen, lineLen), paint);

    canvas.drawLine(Offset(0 + bonderLen, gridSize - bonderLen),
        Offset(0 + bonderLen, gridSize - lineLen), paint);
    canvas.drawLine(Offset(0 + bonderLen, gridSize - bonderLen),
        Offset(lineLen, gridSize - bonderLen), paint);

    canvas.drawLine(Offset(gridSize - bonderLen, gridSize - bonderLen),
        Offset(gridSize - lineLen, gridSize - bonderLen), paint);
    canvas.drawLine(Offset(gridSize - bonderLen, gridSize - bonderLen),
        Offset(gridSize - bonderLen, gridSize - lineLen), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
