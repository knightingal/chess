import 'playground.dart';

List<PosInfo> parseShi(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  int maxX, maxY, minX, minY;
  if (pieceInfo.player == 1) {
    minX = 3;
    minY = 0;
    maxX = 5;
    maxY = 2;
  } else {
    minX = 3;
    minY = 7;
    maxX = 5;
    maxY = 9;
  }

  List<PosInfo> posList = [
    PosInfo(pieceInfo.x + 1, pieceInfo.y + 1),
    PosInfo(pieceInfo.x - 1, pieceInfo.y - 1),
    PosInfo(pieceInfo.x + 1, pieceInfo.y - 1),
    PosInfo(pieceInfo.x - 1, pieceInfo.y + 1),
  ];

  posList.removeWhere((e) {
    if (e.x < minX || e.x > maxX) {
      return true;
    }
    if (e.y < minY || e.y > maxY) {
      return true;
    }
    var target = chessPlayGround.findTarget(e.x, e.y);
    if (target.player == pieceInfo.player) {
      return true;
    }

    return false;
  });

  return posList;
}

List<PosInfo> parseShuai(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  int maxX, maxY, minX, minY;
  if (pieceInfo.player == 1) {
    minX = 3;
    minY = 0;
    maxX = 5;
    maxY = 2;
  } else {
    minX = 3;
    minY = 7;
    maxX = 5;
    maxY = 9;
  }
  List<PosInfo> posList = [
    PosInfo(pieceInfo.x + 1, pieceInfo.y),
    PosInfo(pieceInfo.x - 1, pieceInfo.y),
    PosInfo(pieceInfo.x, pieceInfo.y + 1),
    PosInfo(pieceInfo.x, pieceInfo.y - 1),
  ];

  posList.removeWhere((e) {
    if (e.x < minX || e.x > maxX) {
      return true;
    }
    if (e.y < minY || e.y > maxY) {
      return true;
    }
    var target = chessPlayGround.findTarget(e.x, e.y);
    if (target.player == pieceInfo.player) {
      return true;
    }

    return false;
  });

  return posList;
}

List<PosInfo> parseXiang(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  int maxX, maxY, minX, minY;
  if (pieceInfo.player == 1) {
    minX = 0;
    minY = 0;
    maxX = 8;
    maxY = 4;
  } else {
    minX = 0;
    minY = 5;
    maxX = 8;
    maxY = 9;
  }
  List<PosInfo> posList = [
    PosInfo(pieceInfo.x + 2, pieceInfo.y + 2),
    PosInfo(pieceInfo.x - 2, pieceInfo.y - 2),
    PosInfo(pieceInfo.x + 2, pieceInfo.y - 2),
    PosInfo(pieceInfo.x - 2, pieceInfo.y + 2),
  ];

  posList.removeWhere((e) {
    if (e.x < minX || e.x > maxX) {
      return true;
    }
    if (e.y < minY || e.y > maxY) {
      return true;
    }
    var target = chessPlayGround.findTarget(e.x, e.y);
    if (target.player == pieceInfo.player) {
      return true;
    }

    return false;
  });

  return posList;
}
