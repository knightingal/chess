import 'dart:developer';

import 'package:chess/discover_china/script/computer_player.dart';
import 'package:chess/discover_china/script/tsp.dart';
import 'package:test/test.dart';

import 'dijkstra_test.dart';

void main() {
  test("test 0", () {
    var list0 = [0, 1, 2, 3, 4];
    list0.insert(list0.length, 9);
    log("succ");
  });
  test("test tsp1", () {
    List<DJNode> graph = initGraph3();
    NextMatrix nextMatrix = NextMatrix();
    for (DJNode vNode in graph) {
      List<Path> path = dijkstra(graph, vNode, nextMatrix);
      expect(path.length, graph.length);
      expect(
          path.firstWhere((element) => element.distance == 0).path.length, 0);
    }

    List<DJNode> nodeList = [
      graph[4],
      graph[6],
      graph[1],
      graph[19],
      graph[30]
    ];
    for (DJNode djNode in nodeList) {
      log(djNode.nodeId);
    }
    int distacnce = calDistance(nodeList, nextMatrix);
    log(distacnce.toString());
    expect(distacnce, 19);
  });
  test("test tsp2", () {
    List<DJNode> graph = initGraph3();
    NextMatrix nextMatrix = NextMatrix();
    for (DJNode vNode in graph) {
      List<Path> path = dijkstra(graph, vNode, nextMatrix);
      expect(path.length, graph.length);
      expect(
          path.firstWhere((element) => element.distance == 0).path.length, 0);
    }

    DJNode source = graph.firstWhere((element) => element.nodeId == "北京");

    List<DJNode> nodeList = [
      graph[4],
      graph[8],
      graph[1],
      graph[19],
      graph[30]
    ];
    for (DJNode djNode in nodeList) {
      log(djNode.nodeId);
    }
    List<List<DJNode>> result = tsp(source, nodeList, nextMatrix);
    int distacnce = calDistance([...result[0]], nextMatrix);

    log(distacnce.toString());
    // expect(distacnce, 19);
  });
}
