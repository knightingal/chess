import 'dart:developer';

import '../city_info.dart';
import 'computer_player.dart';

Set<LineInfo> calAllPath(String source, String dest) {
  Set<LineInfo> lineInfoSet = {};
  NextStepNode nextStepNode = nextMatrix.getNodeById(source, dest)!;
  for (DJNode nextNode in nextStepNode.nextNode) {
    var line = lineList
        .where((element) =>
            element.cityName1 == source &&
                element.cityName2 == nextNode.nodeId ||
            element.cityName1 == nextNode.nodeId && element.cityName2 == source)
        .first;
    if (nextNode.nodeId == dest) {
      return {line};
    } else {
      lineInfoSet.add(line);
      lineInfoSet.addAll(calAllPath(nextNode.nodeId, dest));
    }
  }
  return lineInfoSet;
}

NextMatrix initDiscoverGraph() {
  // initLineList();
  // initCityList();
  List<DJNode> djNodeList =
      cityList.keys.map((city) => DJNode(nodeId: city)).toList();
  for (DJNode djNode in djNodeList) {
    var neighborList = lineList
        .where((element) =>
            element.cityName1 == djNode.nodeId ||
            element.cityName2 == djNode.nodeId)
        .map((e) {
          if (e.cityName1 == djNode.nodeId) {
            return e.cityName2;
          } else {
            return e.cityName1;
          }
        })
        .map((neighborName) {
          return djNodeList.firstWhere(
              (element) => element.nodeId == neighborName, orElse: () {
            log("not fount $neighborName");
            // throw IterableElementError.noElement();
            return DJNode(nodeId: "nodeId");
          });
        })
        .map((e) => Neighbor(node: e, weight: 1))
        .toList();
    djNode.neighbors = neighborList;
  }

  // return djNodeList;

  NextMatrix nextMatrix = NextMatrix();
  for (DJNode vNode in djNodeList) {
    dijkstra(djNodeList, vNode, nextMatrix);
    // expect(path.length, graph.length);
    // expect(
    //     path.firstWhere((element) => element.distance == 0).path.length, 0);
  }
  return nextMatrix;
}
