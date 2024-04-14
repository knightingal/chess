import 'dart:developer';

import 'package:chess/discover_china/city_info.dart';
import 'package:chess/discover_china/script/computer_player.dart';
import 'package:test/test.dart';

List<DJNode> initGraph1() {
  DJNode node0 = DJNode(nodeId: "node0");
  DJNode node1 = DJNode(nodeId: "node1");
  DJNode node2 = DJNode(nodeId: "node2");
  DJNode node3 = DJNode(nodeId: "node3");

  node0.neighbors = [
    Neighbor(node: node1, weight: 3),
    Neighbor(node: node2, weight: 2),
  ];

  node1.neighbors = [
    Neighbor(node: node0, weight: 3),
    Neighbor(node: node2, weight: 2),
    Neighbor(node: node3, weight: 1),
  ];
  node2.neighbors = [
    Neighbor(node: node0, weight: 2),
    Neighbor(node: node1, weight: 2),
    Neighbor(node: node3, weight: 1),
  ];

  node3.neighbors = [
    Neighbor(node: node2, weight: 1),
    Neighbor(node: node1, weight: 1),
  ];

  return [node0, node1, node2, node3];
}

List<DJNode> initGraph2() {
  DJNode node0 = DJNode(nodeId: "node0");
  DJNode node1 = DJNode(nodeId: "node1");
  DJNode node2 = DJNode(nodeId: "node2");
  DJNode node3 = DJNode(nodeId: "node3");

  node0.neighbors = [
    Neighbor(node: node1, weight: 3),
    Neighbor(node: node2, weight: 2),
    Neighbor(node: node3, weight: 1),
  ];

  node1.neighbors = [
    Neighbor(node: node0, weight: 3),
    Neighbor(node: node2, weight: 2),
    Neighbor(node: node3, weight: 1),
  ];
  node2.neighbors = [
    Neighbor(node: node0, weight: 2),
    Neighbor(node: node1, weight: 2),
    Neighbor(node: node3, weight: 1),
  ];

  node3.neighbors = [
    Neighbor(node: node2, weight: 1),
    Neighbor(node: node1, weight: 1),
    Neighbor(node: node0, weight: 1),
  ];

  return [node0, node1, node2, node3];
}

List<DJNode> initGraph3() {
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
            log("not fount ${neighborName}");
            // throw IterableElementError.noElement();
            return DJNode(nodeId: "nodeId");
          });
        })
        .map((e) => Neighbor(node: e, weight: 1))
        .toList();
    djNode.neighbors = neighborList;
  }

  return djNodeList;
}

void main() {
  test('test dijkstra 1', () {
    List<DJNode> graph = initGraph1();
    DJNode vNode = graph[0];
    List<Path> path = dijkstra(graph, vNode);
    expect(path.length, 4);
    expect(path.firstWhere((element) => element.distance == 0).path.length, 0);
    Path node3Path = path.firstWhere((element) {
      return element.targetNode == graph[3];
    });
    expect(node3Path.distance, 3);
  });

  test('test dijkstra 2', () {
    List<DJNode> graph = initGraph2();
    DJNode vNode = graph[0];
    List<Path> path = dijkstra(graph, vNode);
    expect(path.length, 4);
    expect(path.firstWhere((element) => element.distance == 0).path.length, 0);
    Path node3Path = path.firstWhere((element) {
      return element.targetNode == graph[3];
    });
    expect(node3Path.distance, 1);
  });

  test('test dijkstra 3', () {
    List<DJNode> graph = initGraph3();
    DJNode vNode = graph[0];
    List<Path> path = dijkstra(graph, vNode);
    expect(path.length, graph.length);
    expect(path.firstWhere((element) => element.distance == 0).path.length, 0);
    // Path node3Path = path.firstWhere((element) {
    //   return element.targetNode == graph[3];
    // });
    // expect(node3Path.distance, 1);
  });
}
