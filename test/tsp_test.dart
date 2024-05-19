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
    int distacnce = calDistance([source, ...result[0]], nextMatrix);

    log(distacnce.toString());
    // expect(distacnce, 19);
    /*
[log] 乌鲁木齐
[log] 敦煌
[log] 佳木斯
[log] 济南
[log] 重庆
[log] parse:北京,乌鲁木齐,
[log] distance:5
[log] parse:北京,敦煌,乌鲁木齐,
[log] distance:5
[log] parse:北京,乌鲁木齐,敦煌,
[log] distance:6
[log] parse:北京,佳木斯,敦煌,乌鲁木齐,
[log] distance:13
[log] parse:北京,敦煌,佳木斯,乌鲁木齐,
[log] distance:21
[log] parse:北京,敦煌,乌鲁木齐,佳木斯,
[log] distance:14
[log] parse:北京,济南,佳木斯,敦煌,乌鲁木齐,
[log] distance:17
[log] parse:北京,佳木斯,济南,敦煌,乌鲁木齐,
[log] distance:16
[log] parse:北京,佳木斯,敦煌,济南,乌鲁木齐,
[log] distance:23
[log] parse:北京,佳木斯,敦煌,乌鲁木齐,济南,
[log] distance:19
[log] parse:北京,重庆,佳木斯,济南,敦煌,乌鲁木齐,
[log] distance:28
[log] parse:北京,佳木斯,重庆,济南,敦煌,乌鲁木齐,
[log] distance:24
[log] parse:北京,佳木斯,济南,重庆,敦煌,乌鲁木齐,
[log] distance:19
[log] parse:北京,佳木斯,济南,敦煌,重庆,乌鲁木齐,
[log] distance:24
[log] parse:北京,佳木斯,济南,敦煌,乌鲁木齐,重庆,
[log] distance:21
[log] 19
    */
  });

  DJNode findNodeByName(List<DJNode> graph, String name) {
    return graph.firstWhere((element) => element.nodeId == name);
  }

  test("test tsp3", () {
    List<DJNode> graph = initGraph3();
    NextMatrix nextMatrix = NextMatrix();
    for (DJNode vNode in graph) {
      List<Path> path = dijkstra(graph, vNode, nextMatrix);
      expect(path.length, graph.length);
      expect(
          path.firstWhere((element) => element.distance == 0).path.length, 0);
    }

    DJNode source = graph.firstWhere((element) => element.nodeId == "北京");

    DJNode node1 = findNodeByName(graph, "佳木斯");
    DJNode node2 = findNodeByName(graph, "济南");
    DJNode node3 = findNodeByName(graph, "敦煌");
    DJNode node4 = findNodeByName(graph, "乌鲁木齐");
    DJNode node5 = findNodeByName(graph, "重庆");
    List<DJNode> nodeList = [node1, node2, node3, node4, node5];

    log("北京->佳木斯, ${nextMatrix.getNode(source, node1)!.distance}");
    log("北京->济南, ${nextMatrix.getNode(source, node2)!.distance}");
    log("北京->敦煌, ${nextMatrix.getNode(source, node3)!.distance}");
    log("北京->乌鲁木齐, ${nextMatrix.getNode(source, node4)!.distance}");
    log("北京->重庆, ${nextMatrix.getNode(source, node5)!.distance}");

    log("佳木斯->济南, ${nextMatrix.getNode(node1, node2)!.distance}");
    log("佳木斯->敦煌, ${nextMatrix.getNode(node1, node3)!.distance}");
    log("佳木斯->乌鲁木齐, ${nextMatrix.getNode(node1, node4)!.distance}");
    log("佳木斯->重庆, ${nextMatrix.getNode(node1, node5)!.distance}");

    log("济南->敦煌, ${nextMatrix.getNode(node2, node3)!.distance}");
    log("济南->乌鲁木齐, ${nextMatrix.getNode(node2, node4)!.distance}");
    log("济南->重庆, ${nextMatrix.getNode(node2, node5)!.distance}");

    log("敦煌->乌鲁木齐, ${nextMatrix.getNode(node3, node4)!.distance}");
    log("敦煌->重庆, ${nextMatrix.getNode(node3, node5)!.distance}");

    log("乌鲁木齐->重庆, ${nextMatrix.getNode(node4, node5)!.distance}");

    for (DJNode djNode in nodeList) {
      log(djNode.nodeId);
    }
    List<List<DJNode>> result = tsp(source, nodeList, nextMatrix);
    int distacnce = calDistance([...result[0]], nextMatrix);

    log(distacnce.toString());
    // expect(distacnce, 19);
    /*

[log] 佳木斯
[log] 济南
[log] 敦煌
[log] 乌鲁木齐
[log] 重庆
[log] parse:北京,佳木斯,
[log] distance:4
[log] parse:北京,济南,佳木斯,
[log] distance:8
[log] parse:北京,佳木斯,济南,
[log] distance:10
[log] parse:北京,敦煌,济南,佳木斯,
[log] distance:15
[log] parse:北京,济南,敦煌,佳木斯,
[log] distance:15
[log] parse:北京,济南,佳木斯,敦煌,
[log] distance:16
[log] parse:北京,乌鲁木齐,敦煌,济南,佳木斯,
[log] distance:17
[log] parse:北京,敦煌,乌鲁木齐,济南,佳木斯,
[log] distance:17
[log] parse:北京,敦煌,济南,乌鲁木齐,佳木斯,
[log] distance:24
[log] parse:北京,敦煌,济南,佳木斯,乌鲁木齐,
[log] distance:24
[log] parse:北京,乌鲁木齐,济南,敦煌,佳木斯,
[log] distance:24
[log] parse:北京,济南,乌鲁木齐,敦煌,佳木斯,
[log] distance:17
[log] parse:北京,济南,敦煌,乌鲁木齐,佳木斯,
[log] distance:17
[log] parse:北京,济南,敦煌,佳木斯,乌鲁木齐,
[log] distance:24
[log] parse:北京,重庆,乌鲁木齐,敦煌,济南,佳木斯,
[log] distance:23
[log] parse:北京,乌鲁木齐,重庆,敦煌,济南,佳木斯,
[log] distance:25
[log] parse:北京,乌鲁木齐,敦煌,重庆,济南,佳木斯,
[log] distance:20
[log] parse:北京,乌鲁木齐,敦煌,济南,重庆,佳木斯,
[log] distance:25
[log] parse:北京,乌鲁木齐,敦煌,济南,佳木斯,重庆,
[log] distance:27
[log] parse:北京,重庆,敦煌,乌鲁木齐,济南,佳木斯,
[log] distance:23
[log] parse:北京,敦煌,重庆,乌鲁木齐,济南,佳木斯,
[log] distance:25
[log] parse:北京,敦煌,乌鲁木齐,重庆,济南,佳木斯,
[log] distance:20
[log] parse:北京,敦煌,乌鲁木齐,济南,重庆,佳木斯,
[log] distance:25
[log] parse:北京,敦煌,乌鲁木齐,济南,佳木斯,重庆,
[log] distance:27
[log] parse:北京,重庆,济南,乌鲁木齐,敦煌,佳木斯,
[log] distance:25
[log] parse:北京,济南,重庆,乌鲁木齐,敦煌,佳木斯,
[log] distance:20
[log] parse:北京,济南,乌鲁木齐,重庆,敦煌,佳木斯,
[log] distance:25
[log] parse:北京,济南,乌鲁木齐,敦煌,重庆,佳木斯,
[log] distance:23
[log] parse:北京,济南,乌鲁木齐,敦煌,佳木斯,重庆,
[log] parse:北京,济南,乌鲁木齐,敦煌,佳木斯,重庆,
[log] distance:27
[log] parse:北京,重庆,济南,敦煌,乌鲁木齐,佳木斯,
[log] distance:25
[log] parse:北京,济南,重庆,敦煌,乌鲁木齐,佳木斯,
[log] distance:20
[log] parse:北京,济南,敦煌,重庆,乌鲁木齐,佳木斯,
[log] distance:25
[log] parse:北京,济南,敦煌,乌鲁木齐,重庆,佳木斯,
[log] distance:23
[log] parse:北京,济南,敦煌,乌鲁木齐,佳木斯,重庆,
[log] distance:27
[log] 20
     */
  });
}
