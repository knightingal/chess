import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_model.dart';

class CityCardList extends StatefulWidget {
  final double gridSize;

  const CityCardList({super.key, required this.gridSize});

  @override
  State<StatefulWidget> createState() {
    return CityCardState();
  }
}

class CityCardState extends State<CityCardList> {
  @override
  void initState() {
    super.initState();
  }

  static const List<Color> ticketColor = [
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    var gridSize = widget.gridSize;
    return Container(
      width: gridSize * 10,
      height: gridSize * 6,
      color: Colors.grey,
      child: Consumer<GameModel>(
        builder: (context, game, child) {
          var playerCityCard =
              game.playerDataList[game.getTabPlayer()].cityCardList;
          var selectedCard =
              game.playerDataList[game.getTabPlayer()].selectedCard;
          int row1Max = min(5, playerCityCard.length);

          List<CityCard> row1 = playerCityCard.sublist(0, row1Max).map((e) {
            return CityCard(
                gridSize: gridSize,
                color: ticketColor[e.ticket - 1],
                cityName: e.cityName,
                selected: e.cityName == selectedCard);
          }).toList();

          List<CityCard> row2 = [];
          if (playerCityCard.length > 5) {
            row2 = playerCityCard.sublist(5, playerCityCard.length).map((e) {
              return CityCard(
                  gridSize: gridSize,
                  color: ticketColor[e.ticket - 1],
                  cityName: e.cityName,
                  selected: e.cityName == selectedCard);
            }).toList();
          }

          return Column(
            children: [
              Row(
                children: [...row1],
              ),
              Row(
                children: [...row2],
              )
            ],
          );
        },
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final double gridSize;
  final Color color;
  final String cityName;
  final bool selected;

  const CityCard({
    super.key,
    required this.gridSize,
    required this.color,
    required this.cityName,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    var backgroundColor = selected ? color : Colors.white;
    var textColor = selected ? Colors.white : color;
    return GestureDetector(
      onTap: () {
        Provider.of<GameModel>(context, listen: false).setSelectCard(cityName);
      },
      child: Container(
        width: gridSize * 2,
        height: gridSize * 3,
        color: backgroundColor,
        child: Center(
          child: Text(
            cityName,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
