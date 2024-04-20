import 'package:chess/discover_china/script/computer_player.dart';
import 'package:flutter/material.dart';

import '../script/discover_graph.dart';

class DijkstraTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NextMatrix nextMatrix = initDiscoverGraph();

    TableCell toTableCell(NextStepNode nextStepNode) {
      List<Text> texts = nextStepNode.nextNode.map((node) {
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

    return MaterialApp(
        title: "Discover",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Table(
          border: TableBorder.all(),
          // columnWidths: const <int, TableColumnWidth>{
          //   0: FixedColumnWidth(64),
          // 1: FixedColumnWidth(64),
          // 2: FixedColumnWidth(64),
          // },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            ...tableRows
            //   TableRow(
            //     children: <Widget>[
            //       Container(
            //         height: 32,
            //         color: Colors.green,
            //       ),
            //       TableCell(
            //         verticalAlignment: TableCellVerticalAlignment.top,
            //         child: Container(
            //           height: 32,
            //           width: 32,
            //           color: Colors.red,
            //         ),
            //       ),
            //       Container(
            //         height: 64,
            //         color: Colors.blue,
            //       ),
            //     ],
            //   ),
            //   TableRow(
            //     decoration: const BoxDecoration(
            //       color: Colors.grey,
            //     ),
            //     children: <Widget>[
            //       Container(
            //         height: 64,
            //         width: 128,
            //         color: Colors.purple,
            //       ),
            //       Container(
            //         height: 32,
            //         color: Colors.yellow,
            //       ),
            //       Center(
            //         child: Container(
            //           height: 32,
            //           width: 32,
            //           color: Colors.orange,
            //         ),
            //       ),
            //     ],
            //   ),
          ],
        ));
  }
}
