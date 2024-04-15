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
      graph.where((value) => value != vNode).toList();
  List<Path> uList = graphWithoutVNode.map((node) {
    var distance = 999;
    List<DJNode> path = [];

    List<Neighbor> vNeighbor =
        node.neighbors.where((neighbor) => neighbor.node == vNode).toList();
    if (vNeighbor.isNotEmpty) {
      distance = vNeighbor[0].weight;
      path.add(node);
    }
    return Path(targetNode: node, path: path, distance: distance);
  }).toList();

  while (uList.isNotEmpty) {
    uList.sort((a, b) => a.distance - b.distance);
    Path u = uList.removeAt(0);
    DJNode uNode = u.targetNode;
    sList.add(u);
    for (Neighbor uNeighbor in uNode.neighbors) {
      for (Path restUPath in uList) {
        if (restUPath.targetNode == uNeighbor.node &&
            uNeighbor.weight + u.distance < restUPath.distance) {
          restUPath.distance = uNeighbor.weight + u.distance;
          restUPath.path = u.path.map((e) => e).toList();
          restUPath.path.add(restUPath.targetNode);
        }
      }
    }
  }

  return sList;
}
