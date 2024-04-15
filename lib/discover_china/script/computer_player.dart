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

List<Path> dijkstra(List<DJNode> graph, DJNode sourceNode) {
  List<Path> sList = [Path(targetNode: sourceNode, path: [], distance: 0)];

  // init each target path to sourceNode
  List<DJNode> graphWithoutVNode =
      graph.where((value) => value != sourceNode).toList();
  List<Path> restPathList = graphWithoutVNode.map((node) {
    var distance = 999;
    List<DJNode> path = [];

    // if is neighbor to source node, create a distanced path
    // else, create an unreached path
    List<Neighbor> vNeighbor = node.neighbors
        .where((neighbor) => neighbor.node == sourceNode)
        .toList();
    if (vNeighbor.isNotEmpty) {
      distance = vNeighbor[0].weight;
      path.add(node);
    }
    return Path(targetNode: node, path: path, distance: distance);
  }).toList();

  while (restPathList.isNotEmpty) {
    restPathList.sort((a, b) => a.distance - b.distance);
    Path topRestPath = restPathList.removeAt(0);
    DJNode targetNode = topRestPath.targetNode;
    sList.add(topRestPath);
    for (Neighbor targetNeighbor in targetNode.neighbors) {
      for (Path restPath in restPathList) {
        if (restPath.targetNode == targetNeighbor.node &&
            targetNeighbor.weight + topRestPath.distance < restPath.distance) {
          // find a nearer path
          restPath.distance = targetNeighbor.weight + topRestPath.distance;
          restPath.path = [...topRestPath.path];
          restPath.path.add(restPath.targetNode);
        }
      }
    }
  }

  return sList;
}
