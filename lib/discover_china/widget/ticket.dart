import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_model.dart';

class TicketList extends StatefulWidget {
  final double gridSize;

  const TicketList({super.key, required this.gridSize});

  @override
  State<StatefulWidget> createState() {
    return TicketState();
  }
}

class TicketState extends State<TicketList> {
  @override
  Widget build(BuildContext context) {
    var gridSize = widget.gridSize;
    return Container(
      width: gridSize * 10,
      height: gridSize * 3,
      color: Colors.green,
      child: Consumer<GameModel>(builder: (context, game, child) {
        var ticketCount = game.playerDataList[game.getTabPlayer()].ticketCount;
        return Row(
          children: [
            SignleTicket(
              gridSize: gridSize,
              color: Colors.red,
              count: ticketCount[0],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.purple,
              count: ticketCount[1],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.blue,
              count: ticketCount[2],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.green,
              count: ticketCount[3],
            ),
            SignleTicket(
              gridSize: gridSize,
              color: Colors.orange,
              count: ticketCount[4],
            ),
          ],
        );
      }),
    );
  }
}

class SignleTicket extends StatelessWidget {
  final double gridSize;
  final Color color;
  final int count;

  const SignleTicket(
      {super.key,
      required this.gridSize,
      required this.color,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize * 2,
      height: gridSize * 3,
      color: color,
      child: Center(
        child: Text(count.toString()),
      ),
    );
  }
}
