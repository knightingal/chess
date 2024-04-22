import 'package:chess/discover_china/script/computer_player.dart';
import 'package:flutter/material.dart';

import '../script/discover_graph.dart';

class DijkstraTest extends StatelessWidget {
  const DijkstraTest({super.key});

  @override
  Widget build(BuildContext context) {
    NextMatrix nextMatrix = initDiscoverGraph();

    TableCell toTableCell(NextStepNode nextStepNode) {
      List<Widget> texts = nextStepNode.nextNode.map((node) {
        return Text(node.nodeId);
      }).toList();
      return TableCell(
        child: Column(
          children: [...texts],
        ),
      );
    }

    TableRow toTableRow(Map<String, NextStepNode> lineItem) {
      return TableRow(
          children: lineItem.values.map((e) => toTableCell(e)).toList());
    }

    List<TableRow> tableRows = nextMatrix.matrix.values.map((e) {
      return toTableRow(e);
    }).toList();

    var table = Table(
        children: [...tableRows],
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle);

    return MaterialApp(
        title: "Discover",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
          body: Scrollbar(
            child: SingleChildScrollView(
              primary: true,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                primary: true,
                child: table,
              ),
            ),
          ),
        ));
  }
}
