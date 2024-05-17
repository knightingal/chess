import 'dart:developer';

import 'computer_player.dart';

List<List<DJNode>> tsp(
    DJNode source, List<DJNode> nodeList, NextMatrix nextMatrix) {
  DJNode node0 = source;
  List<List<DJNode>> result = [
    [node0]
  ];
  while (nodeList.isNotEmpty) {
    int distanceTemp = 99999;
    DJNode nodeN = nodeList.removeAt(0);
    List<List<DJNode>> minList = [];
    for (List<DJNode> pathItem in result) {
      for (int i = 1; i <= pathItem.length; i++) {
        List<DJNode> resultTemp = [...pathItem];
        resultTemp.insert(i, nodeN);
        log("parse:${nodeListToString(resultTemp)}");
        int calDistanceTemp = calDistance([...resultTemp], nextMatrix);
        log("distance:$calDistanceTemp");
        if (calDistanceTemp < distanceTemp) {
          minList = [resultTemp];
          distanceTemp = calDistanceTemp;
        } else if (calDistanceTemp == distanceTemp) {
          minList.add(resultTemp);
        }
      }
      result = minList;
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
