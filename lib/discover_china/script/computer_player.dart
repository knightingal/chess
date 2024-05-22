import 'dart:convert';
import 'dart:developer';

class DJNode {
  final String nodeId;
  List<Neighbor> neighbors = [];

  DJNode({required this.nodeId});

  Map<String, dynamic> toJson() {
    return {"nodeid": nodeId};
  }
}

class Neighbor {
  final DJNode node;
  final int weight;

  Neighbor({required this.node, required this.weight});
}

class Path {
  late DJNode targetNode;
  List<DJNode> path = [];
  Set<DJNode> nextStep = {};
  int distance = 0;

  Path(
      {required this.targetNode,
      required this.path,
      required this.distance,
      required this.nextStep});
}

class NextStepNode {
  Set<DJNode> nextNode = {};
  int distance = 0;
  Map<String, dynamic> toJson() {
    return {"nextNode": nextNode.toList(), "distance": distance};
  }
}

class NextMatrix {
  Map<String, Map<String, NextStepNode>> matrix = {};

  List<DJNode> djNodeList = [];

  void addNode(DJNode source, DJNode target, NextStepNode nextStepNode) {
    if (!matrix.containsKey(source.nodeId)) {
      matrix[source.nodeId] = {};
    }
    matrix[source.nodeId]![target.nodeId] = nextStepNode;
  }

  NextStepNode? getNode(DJNode source, DJNode target) {
    return matrix[source.nodeId]![target.nodeId];
  }

  NextStepNode? getNodeById(String source, String target) {
    return matrix[source]![target];
  }

  void printMatrix() {
    var matrixJson = jsonEncode(matrix);
    log(matrixJson);
  }
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

List<Path> dijkstra(
    List<DJNode> graph, DJNode sourceNode, NextMatrix nextMatrix) {
  Map<DJNode, Path> sList = {
    sourceNode:
        Path(targetNode: sourceNode, path: [], distance: 0, nextStep: {})
  };

  /*
  init each target path to sourceNode
   */
  List<DJNode> graphWithoutVNode =
      graph.where((value) => value != sourceNode).toList();
  log("init rest path list");
  List<Path> restPathList = graphWithoutVNode.map((node) {
    /*
    if is neighbor to source node, create a distanced path
    else, create an unreached path
     */
    var targetList = sourceNode.neighbors
        .where((neighbor) => neighbor.node == node)
        .toList();
    if (targetList.isNotEmpty) {
      var distance = targetList[0].weight;
      nextMatrix.addNode(
          sourceNode,
          node,
          NextStepNode()
            ..distance = distance
            ..nextNode = {node});
      return Path(
          targetNode: node,
          path: [node],
          distance: targetList[0].weight,
          nextStep: {node});
    } else {
      var distance = 999;
      nextMatrix.addNode(
          sourceNode,
          node,
          NextStepNode()
            ..distance = distance
            ..nextNode = {node});
      return Path(targetNode: node, path: [], distance: 999, nextStep: {});
    }
  }).toList();
  while (restPathList.isNotEmpty) {
    restPathList.sort((a, b) => a.distance - b.distance);
    Path topRestPath = restPathList.removeAt(0);

    nextMatrix.addNode(
        sourceNode,
        topRestPath.targetNode,
        NextStepNode()
          ..distance = topRestPath.distance
          ..nextNode = topRestPath.nextStep);
    DJNode targetNode = topRestPath.targetNode;
    sList.addAll({targetNode: topRestPath});
    for (Neighbor targetNeighbor in targetNode.neighbors) {
      List<Path> restPaths = restPathList
          .where((restPath) => restPath.targetNode == targetNeighbor.node)
          .toList();
      if (restPaths.isEmpty) {
        continue;
      }
      var restPath = restPaths[0];
      if (targetNeighbor.weight + topRestPath.distance < restPath.distance) {
        restPath.distance = targetNeighbor.weight + topRestPath.distance;
        restPath.path = [...topRestPath.path, restPath.targetNode];
        restPath.nextStep = {};
        for (DJNode path in topRestPath.path) {
          restPath.nextStep.addAll(sList[path]!.nextStep);
        }
      } else if (targetNeighbor.weight + topRestPath.distance ==
          restPath.distance) {
        log("find a equal distance path to ${targetNeighbor.node.nodeId} !!!");
        restPath.path = [...topRestPath.path, restPath.targetNode];
        for (DJNode path in topRestPath.path) {
          restPath.nextStep.addAll(sList[path]!.nextStep);
        }
      }
    }
  }

  return sList.values.toList();
}
