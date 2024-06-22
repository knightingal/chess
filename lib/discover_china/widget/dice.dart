import 'package:chess/discover_china/game_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiceWidget extends StatefulWidget {
  final double gridSize;

  const DiceWidget({super.key, required this.gridSize});

  @override
  State<DiceWidget> createState() => DiceState();
}

class DiceState extends State<DiceWidget> {
  DiceState();

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
          Provider.of<GameModel>(context, listen: false).nextTurn();
        },
        child: Row(
          children: [
            Consumer<GameModel>(builder: (context, game, child) {
              return SingleDice(
                gridSize: widget.gridSize,
                color: diceColors[game.dice1],
                used: game.dice1Used,
              );
            }),
            Consumer<GameModel>(builder: (context, game, child) {
              return SingleDice(
                gridSize: widget.gridSize,
                color: diceColors[game.dice2],
                used: game.dice2Used,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class SingleDice extends StatelessWidget {
  final double gridSize;
  final Color color;
  final bool used;

  const SingleDice(
      {super.key,
      required this.gridSize,
      required this.color,
      required this.used});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 5,
      height: gridSize * 5,
      color: color,
      child: used ? const Text("\u{2705}") : null,
    );
  }
}
