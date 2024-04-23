import 'dart:developer';

import 'package:chess/discover_china/script/computer_player.dart';
import 'package:chess/discover_china/script/tsp.dart';
import 'package:test/test.dart';

import 'dijkstra_test.dart';

void main() {
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
}
