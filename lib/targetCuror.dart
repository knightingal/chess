import 'package:flutter/widgets.dart';

import 'main.dart';

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

    canvas.drawLine(Offset(0, 0), Offset(lineLen, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, lineLen), paint);

    canvas.drawLine(Offset(gridSize, 0), Offset(gridSize - lineLen, 0), paint);
    canvas.drawLine(Offset(gridSize, 0), Offset(gridSize, lineLen), paint);

    canvas.drawLine(Offset(0, gridSize), Offset(0, gridSize - lineLen), paint);
    canvas.drawLine(Offset(0, gridSize), Offset(lineLen, gridSize), paint);

    canvas.drawLine(Offset(gridSize, gridSize),
        Offset(gridSize - lineLen, gridSize), paint);
    canvas.drawLine(Offset(gridSize, gridSize),
        Offset(gridSize, gridSize - lineLen), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
