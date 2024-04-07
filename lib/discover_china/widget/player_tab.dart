import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_model.dart';
import 'widget_static_data.dart';

class PlayerTabs extends StatelessWidget {
  final double gridSize;

  const PlayerTabs({super.key, required this.gridSize});

  List<PlayerTab> getTabs(double gridSize, double height, int playerCount) {
    var playerColors = [Colors.red, Colors.blue, Colors.orange, Colors.green];
    List<PlayerTab> playerTabs = List.generate(playerCount, (i) {
      return PlayerTab(
        playerIndex: i,
        gridSize: gridSize,
        tabHeight: height / playerCount,
        color: playerColors[i],
      );
    });

    return playerTabs;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => gameModel,
      child: SizedBox(
        width: gridSize * playerTabWidth,
        height: gridSize * heightGridCount,
        child: Column(
          children: [...getTabs(gridSize, height, 2)],
        ),
      ),
    );
  }
}

class PlayerTab extends StatelessWidget {
  final double gridSize;
  final double tabHeight;
  final Color color;
  final int playerIndex;

  const PlayerTab(
      {super.key,
      required this.playerIndex,
      required this.gridSize,
      required this.tabHeight,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      Provider.of<GameModel>(context, listen: false).setTabPlayer(playerIndex);
    }, child: Consumer<GameModel>(
      builder: ((context, game, child) {
        var playIndexText =
            "$playerIndex${game.currentPlayer() == playerIndex ? "\u{2705}" : ""}";
        if (game.getTabPlayer() != playerIndex) {
          return Container(
            width: gridSize,
            height: tabHeight,
            color: Colors.white,
            child: Center(
              child: Text(
                playIndexText,
                style: TextStyle(color: color),
              ),
            ),
          );
        } else {
          return Container(
            width: gridSize,
            height: tabHeight,
            color: color,
            child: Center(
              child: Text(
                playIndexText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }),
    ));
  }
}
