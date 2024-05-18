import 'dart:developer';

import 'computer_player.dart';

List<List<DJNode>> tspMisstake(
    DJNode source, List<DJNode> nodeList, NextMatrix nextMatrix) {
  int currMinDistance = 99999;
  List<List<DJNode>> result = [];
  if (nodeList.length == 1) {
    return [nodeList];
  } else {
    for (int i = 0; i < nodeList.length; i++) {
      List<DJNode> tmpList = [...nodeList];
      DJNode outNode = tmpList.removeAt(i);
      List<List<DJNode>> subCollect = tsp(source, tmpList, nextMatrix);
      for (List<DJNode> subItemList in subCollect) {
        var targetList = [source, ...subItemList, outNode];
        int calDistanceTemp = calDistance(targetList, nextMatrix);
        if (calDistanceTemp < currMinDistance) {
          result = [
            [...subItemList, outNode]
          ];
          currMinDistance = calDistanceTemp;
        } else if (calDistanceTemp == currMinDistance) {
          result.add([...subItemList, outNode]);
        }
      }
    }
  }
  return result;
}

List<List<DJNode>> tsp(
    DJNode source, List<DJNode> nodeList, NextMatrix nextMatrix) {
  List<List<DJNode>> result = [];
  List<List<DJNode>> subCollect = tspInnerLoop(nodeList, nextMatrix);
  int currMinDistance = 99999;
  for (List<DJNode> subCollectItem in subCollect) {
    var targetCollect = [source, ...subCollectItem];
    int distance = calDistance(targetCollect, nextMatrix);
    if (distance < currMinDistance) {
      result = [
        [source, ...subCollectItem]
      ];
      currMinDistance = distance;
    } else if (distance == currMinDistance) {
      result.add([source, ...subCollectItem]);
    }
  }

  return result;
}

List<List<DJNode>> tspInnerLoop(List<DJNode> nodeList, NextMatrix nextMatrix) {
  List<List<DJNode>> result = [];
  if (nodeList.length == 1) {
    return [nodeList];
  } else {
    for (int i = 0; i < nodeList.length; i++) {
      List<DJNode> tmpList = [...nodeList];
      DJNode outNode = tmpList.removeAt(i);
      List<List<DJNode>> subCollect = tspInnerLoop(tmpList, nextMatrix);
      for (List<DJNode> subItemList in subCollect) {
        var targetList = [...subItemList, outNode];
        result.add(targetList);
      }
    }
  }
  return result;
}

String nodeListToString(List<DJNode> djNodeList) {
  String buf = "";
  for (DJNode jdNode in djNodeList) {
    buf += jdNode.nodeId + ",";
  }
  return buf;
}

int calDistance(List<DJNode> nodeList, NextMatrix nextMatrix) {
  int distance = 0;
  DJNode node0 = nodeList.removeAt(0);
  DJNode nodeN = nodeList.removeAt(0);
  DJNode nodeM = nodeN;
  distance += nextMatrix.getNode(node0, nodeN)!.distance;
  while (nodeList.isNotEmpty) {
    nodeN = nodeList.removeAt(0);
    distance += nextMatrix.getNode(nodeM, nodeN)!.distance;
    nodeM = nodeN;
  }

  return distance;
}
