import 'package:flutter/foundation.dart';

class FindPath {}

class DJNode {
  final String nodeId;
  List<Neighbor> neighbors = [];

  DJNode({required this.nodeId});
}

class Neighbor {
  final DJNode node;
  final int weight;

  Neighbor({required this.node, required this.weight});
}

class Path {
  late DJNode targetNode;
  List<DJNode> path = [];
  int distance = 0;

  Path({required this.targetNode, required this.path, required this.distance});
}

List<Path> dijkstra(List<DJNode> graph, DJNode vNode) {
  List<Path> sList = [Path(targetNode: vNode, path: [], distance: 0)];
  List<DJNode> graphWithoutVNode =
      graph.takeWhile((value) => value != vNode).toList();
  List<Path> uList = graphWithoutVNode.map((node) {
    var distance = 999;
    List<DJNode> path = [];

    List<Neighbor> vNeighbor =
        node.neighbors.takeWhile((neighbor) => neighbor.node == vNode).toList();
    if (vNeighbor.length != 0) {
      distance = vNeighbor[0].weight;
      path.add(node);
    }
    return Path(targetNode: node, path: path, distance: distance);
  }).toList();

  while (uList.length > 0) {
    uList.sort((a, b) => a.distance - b.distance);
    var u = uList.removeAt(0);
    var uNode = u.targetNode;
    sList.add(u);
    uNode.neighbors.forEach((uNeighbor) {
      uList.forEach((restUPath) {
        if (restUPath.targetNode == uNeighbor.node &&
            uNeighbor.weight + u.distance < restUPath.distance) {
          restUPath.distance = uNeighbor.weight + u.distance;
          // u.path.coypWithin <- what is this?
          restUPath.path = u.path.map((e) => e).toList();
          restUPath.path.add(restUPath.targetNode);
        }
      });
    });
  }

  return sList;
}
