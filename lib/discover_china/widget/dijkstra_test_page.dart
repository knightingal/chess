import 'package:chess/discover_china/city_info.dart';
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

    List<String> cityNameList = cityList.keys.toList();

    TableRow toTableRow(String sourceName, Map<String, NextStepNode> lineItem,
        List<String> cityNameList) {
      TableCell emptyCell = const TableCell(
        child: Text(""),
      );
      List<TableCell> cellList = List.generate(cityNameList.length, (i) {
        return emptyCell;
      });

      for (var item in lineItem.entries) {
        cellList[cityNameList.indexOf(item.key)] = toTableCell(item.value);
      }

      return TableRow(children: [
        TableCell(
          child: Column(
            children: [
              Text(
                sourceName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
        ),
        ...cellList
      ]);
    }

    TableRow toHeaderRow(List<String> cityNameList) {
      return TableRow(children: [
        const TableCell(child: Text("")),
        ...cityNameList.map((e) {
          return TableCell(
              child: Column(
            children: [
              Text(
                e,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ));
        }).toList()
      ]);
    }

    List<TableRow> tableRows = [
      toHeaderRow(cityNameList),
      ...nextMatrix.matrix.entries.map((e) {
        return toTableRow(e.key, e.value, cityNameList);
      }).toList()
    ];

    var table = Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
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
