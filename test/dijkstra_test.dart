import 'dart:convert';
import 'dart:developer';

import 'package:chess/discover_china/city_info.dart';
import 'package:chess/discover_china/script/computer_player.dart';
import 'package:chess/discover_china/script/discover_graph.dart';
import 'package:test/test.dart';

List<DJNode> initGraph1() {
  DJNode nodeS = DJNode(nodeId: "nodeS");
  DJNode nodeT = DJNode(nodeId: "nodeT");
  DJNode nodeY = DJNode(nodeId: "nodeY");
  DJNode nodeX = DJNode(nodeId: "nodeX");
  DJNode nodeZ = DJNode(nodeId: "nodeZ");

  nodeS.neighbors = [
    Neighbor(node: nodeT, weight: 10),
    Neighbor(node: nodeY, weight: 5),
  ];

  nodeT.neighbors = [
    Neighbor(node: nodeX, weight: 1),
    Neighbor(node: nodeY, weight: 2),
  ];

  nodeY.neighbors = [
    Neighbor(node: nodeT, weight: 5),
    Neighbor(node: nodeX, weight: 9),
    Neighbor(node: nodeZ, weight: 2),
  ];

  nodeX.neighbors = [
    Neighbor(node: nodeZ, weight: 4),
  ];

  nodeZ.neighbors = [
    Neighbor(node: nodeS, weight: 7),
    Neighbor(node: nodeX, weight: 6),
  ];

  return [nodeS, nodeY, nodeT, nodeX, nodeZ];
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

List<DJNode> initGraph4() {
  DJNode node0 = DJNode(nodeId: "node0");
  DJNode node1 = DJNode(nodeId: "node1");
  DJNode node2 = DJNode(nodeId: "node2");
  DJNode node3 = DJNode(nodeId: "node3");
  DJNode nodeX = DJNode(nodeId: "nodeX");

  node0.neighbors = [
    Neighbor(node: node1, weight: 1),
    Neighbor(node: node2, weight: 2),
    Neighbor(node: node3, weight: 3),
  ];

  node1.neighbors = [
    Neighbor(node: node2, weight: 1),
    Neighbor(node: node3, weight: 2),
  ];

  node2.neighbors = [
    Neighbor(node: node3, weight: 1),
  ];

  node3.neighbors = [
    Neighbor(node: nodeX, weight: 1),
  ];

  return [node0, node1, node2, node3, nodeX];
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
            log("not fount $neighborName");
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
    log("start test1");
    List<DJNode> graph = initGraph1();
    DJNode vNode = graph[0];
    NextMatrix nextMatrix = NextMatrix();
    List<Path> path = dijkstra(graph, vNode, nextMatrix);
    expect(path.length, 5);
    expect(path.firstWhere((element) => element.distance == 0).path.length, 0);
  });

  test('test dijkstra 2', () {
    List<DJNode> graph = initGraph2();
    DJNode vNode = graph[0];
    NextMatrix nextMatrix = NextMatrix();
    List<Path> path = dijkstra(graph, vNode, nextMatrix);
    expect(path.length, 4);
    expect(path.firstWhere((element) => element.distance == 0).path.length, 0);
    Path node3Path = path.firstWhere((element) {
      return element.targetNode == graph[3];
    });
    expect(node3Path.distance, 1);
  });

  test('test dijkstra 3', () {
    List<DJNode> graph = initGraph3();
    NextMatrix nextMatrix = NextMatrix();
    for (DJNode vNode in graph) {
      List<Path> path = dijkstra(graph, vNode, nextMatrix);
      expect(path.length, graph.length);
      expect(
          path.firstWhere((element) => element.distance == 0).path.length, 0);
    }
    nextMatrix.printMatrix();
    log("succ");
  });

  test('test dijkstra 5', () {
    initCityList();
    initLineList();
    initNextMatrix();

    var allPath = calAllPath("北京", "南京");
    log("succ");
  });

  test('test dijkstra 4', () {
    List<DJNode> graph = initGraph4();
    NextMatrix nextMatrix = NextMatrix();
    for (DJNode vNode in graph) {
      List<Path> path = dijkstra(graph, vNode, nextMatrix);
      expect(path.length, graph.length);
      expect(
          path.firstWhere((element) => element.distance == 0).path.length, 0);
    }
    log("succ");
  });

  test('json test', () {
    DJNode node = DJNode(nodeId: "node1");
    // Map<String, DJNode> nodeMap = {"1": node};
    NextStepNode nextStepNode = NextStepNode()
      ..distance = 1
      ..nextNode = {node};
    var text = jsonEncode(nextStepNode);
    log(text);
    Map<String, Map<String, NextStepNode>> matrix = {
      "node1": {"node1": nextStepNode}
    };
    var matrixText = jsonEncode(matrix);
    log(matrixText);
  });
}
