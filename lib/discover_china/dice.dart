import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final double gridSize;

  const DiceWidget({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 10,
      height: gridSize * 5,
      color: Colors.lightBlue,
      child: GestureDetector(
        onTapDown: (e) {
          // dev.log("dice taped");
          int dice1 = Random().nextInt(6) + 1;
          int dice2 = Random().nextInt(6) + 1;

          dev.log("dice taped $dice1 $dice2");
        },
        child: Row(
          children: [
            SingleDice(gridSize: gridSize, color: Colors.red),
            SingleDice(gridSize: gridSize, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}

class SingleDice extends StatelessWidget {
  final double gridSize;
  final Color color;

  const SingleDice({super.key, required this.gridSize, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 5,
      height: gridSize * 5,
      color: color,
    );
  }
}
