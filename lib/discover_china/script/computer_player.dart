import 'dart:developer';

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

String pathToString(List<DJNode> path) {
  String ret = "";
  ret += "[";
  for (DJNode node in path) {
    ret += node.nodeId;
    ret += ",";
  }
  ret += "]";
  return ret;
}

List<Path> dijkstra(List<DJNode> graph, DJNode sourceNode) {
  List<Path> sList = [Path(targetNode: sourceNode, path: [], distance: 0)];

  // init each target path to sourceNode
  List<DJNode> graphWithoutVNode =
      graph.where((value) => value != sourceNode).toList();
  log("init rest path list");
  List<Path> restPathList = graphWithoutVNode.map((node) {
    // if is neighbor to source node, create a distanced path
    // else, create an unreached path
    log("process target node:${node.nodeId}");
    var targetList = sourceNode.neighbors
        .where((neighbor) => neighbor.node == node)
        .toList();
    if (targetList.isNotEmpty) {
      var path = [node];
      var distance = targetList[0].weight;
      log("is neighbor to source, ${pathToString(path)}, $distance");
      log("process target node:${node.nodeId} end");
      return Path(
          targetNode: node, path: [node], distance: targetList[0].weight);
    } else {
      List<DJNode> path = [];
      var distance = 999;
      log("not neighbor to source, ${pathToString(path)}, $distance");
      log("process target node:${node.nodeId} end");
      return Path(targetNode: node, path: [], distance: 999);
    }
  }).toList();

  while (restPathList.isNotEmpty) {
    restPathList.sort((a, b) => a.distance - b.distance);
    Path topRestPath = restPathList.removeAt(0);
    log("pop path to ${topRestPath.targetNode.nodeId}");
    DJNode targetNode = topRestPath.targetNode;
    sList.add(topRestPath);
    for (Neighbor targetNeighbor in targetNode.neighbors) {
      log("process neighbot ${targetNeighbor.node.nodeId}");
      List<Path> restPaths = restPathList
          .where((restPath) => restPath.targetNode == targetNeighbor.node)
          .toList();
      if (restPaths.isEmpty) {
        continue;
      }
      var restPath = restPaths[0];
      if (targetNeighbor.weight + topRestPath.distance < restPath.distance) {
        log("find a nearer path to ${targetNeighbor.node.nodeId} !!!");
        restPath.distance = targetNeighbor.weight + topRestPath.distance;
        restPath.path = [...topRestPath.path, restPath.targetNode];
        log("distance:${restPath.distance}, path:${pathToString(restPath.path)}");
      }
    }
    log("pop path to ${topRestPath.targetNode.nodeId} end");
  }

  return sList;
}
