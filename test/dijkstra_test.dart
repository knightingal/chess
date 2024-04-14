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
}
