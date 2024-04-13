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
}

List<Path> dijkstra(List<DJNode> graph, DJNode vNode) {
  return [];
}
