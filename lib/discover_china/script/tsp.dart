import 'computer_player.dart';

List<DJNode> tsp(DJNode source, List<DJNode> nodeList, NextMatrix nextMatrix) {
  DJNode node0 = source;
  List<DJNode> result = [node0];
  while (nodeList.isNotEmpty) {
    int distanceTemp = 99999;
    DJNode nodeN = nodeList.removeAt(0);
    List<DJNode> minList = [];
    for (int i = 1; i <= result.length; i++) {
      List<DJNode> resultTemp = [...result];
      resultTemp.insert(i, nodeN);
      int calDistanceTemp = calDistance([...resultTemp], nextMatrix);
      if (calDistanceTemp < distanceTemp) {
        minList = resultTemp;
        distanceTemp = calDistanceTemp;
      }
    }
    result = minList;
  }
  return result;
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
