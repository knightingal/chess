import 'computer_player.dart';

void tsp(List<DJNode> nodeList, NextMatrix nextMatrix) {}

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
