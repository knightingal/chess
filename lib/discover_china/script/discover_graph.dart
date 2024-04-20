import 'dart:developer';

import '../city_info.dart';
import 'computer_player.dart';

NextMatrix initDiscoverGraph() {
  initLineList();
  initCityList();
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
