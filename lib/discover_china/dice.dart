import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

class DiceWidget extends StatefulWidget {
  final double gridSize;

  const DiceWidget({super.key, required this.gridSize});

  @override
  State<DiceWidget> createState() => DiceState();
}

class DiceState extends State<DiceWidget> {
  DiceState();

  int dice1 = Random().nextInt(6);
  int dice2 = Random().nextInt(6);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.gridSize * 10,
      height: widget.gridSize * 5,
      color: Colors.lightBlue,
      child: GestureDetector(
        onTapDown: (e) {
          // dev.log("dice taped");
          dice1 = Random().nextInt(6);
          dice2 = Random().nextInt(6);

          dev.log("dice taped $dice1 $dice2");
          setState(() {});
        },
        child: Row(
          children: [
            SingleDice(gridSize: widget.gridSize, color: diceColors[dice1]),
            SingleDice(gridSize: widget.gridSize, color: diceColors[dice2]),
          ],
        ),
      ),
    );
  }
}

List<Color> diceColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.white
];

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
