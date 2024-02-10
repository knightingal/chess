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
  List<PosInfo> calPathPos(PosInfo start, PosInfo end) {
    return [PosInfo((start.x + end.x) ~/ 2, (start.y + end.y) ~/ 2)];
  }

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

    var pathPos = calPathPos(PosInfo(pieceInfo.x, pieceInfo.y), e);
    if (pathPos.any((e) {
      var target = chessPlayGround.findTarget(e.x, e.y);
      return target.valid();
    })) {
      return true;
    }

    return false;
  });

  return posList;
}

List<PosInfo> parseMa(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  List<PosInfo> calPathPos(PosInfo start, PosInfo end) {
    var diffY = end.y - start.y;
    var diffX = end.x - start.x;
    if (diffY == -2 || diffY == 2) {
      return [PosInfo(start.x, start.y + diffY ~/ 2)];
    } else {
      return [PosInfo(start.x + diffX ~/ 2, start.y)];
    }
  }

  int maxX, maxY, minX, minY;
  minX = 0;
  minY = 0;
  maxX = 8;
  maxY = 9;
  List<PosInfo> posList = [
    PosInfo(pieceInfo.x + 2, pieceInfo.y + 1),
    PosInfo(pieceInfo.x + 2, pieceInfo.y - 1),
    PosInfo(pieceInfo.x + 1, pieceInfo.y + 2),
    PosInfo(pieceInfo.x + 1, pieceInfo.y - 2),
    PosInfo(pieceInfo.x - 2, pieceInfo.y + 1),
    PosInfo(pieceInfo.x - 2, pieceInfo.y - 1),
    PosInfo(pieceInfo.x - 1, pieceInfo.y + 2),
    PosInfo(pieceInfo.x - 1, pieceInfo.y - 2),
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

    var pathPos = calPathPos(PosInfo(pieceInfo.x, pieceInfo.y), e);
    if (pathPos.any((e) {
      var target = chessPlayGround.findTarget(e.x, e.y);
      return target.valid();
    })) {
      return true;
    }

    return false;
  });

  return posList;
}

List<PosInfo> parseJu(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  int maxX, maxY, minX, minY;
  minX = 0;
  minY = 0;
  maxX = 8;
  maxY = 9;
  List<PosInfo> posList = [];
  for (var x = pieceInfo.x + 1; x <= maxX; x++) {
    var target = chessPlayGround.findTarget(x, pieceInfo.y);
    if (target.player == pieceInfo.player) {
      break;
    }

    posList.add(PosInfo(x, pieceInfo.y));
    if (target.valid() && target.player != pieceInfo.player) {
      break;
    }
  }
  for (var x = pieceInfo.x - 1; x >= minX; x--) {
    var target = chessPlayGround.findTarget(x, pieceInfo.y);
    if (target.player == pieceInfo.player) {
      break;
    }

    posList.add(PosInfo(x, pieceInfo.y));
    if (target.valid() && target.player != pieceInfo.player) {
      break;
    }
  }
  for (var y = pieceInfo.y + 1; y <= maxY; y++) {
    var target = chessPlayGround.findTarget(pieceInfo.x, y);
    if (target.player == pieceInfo.player) {
      break;
    }

    posList.add(PosInfo(pieceInfo.x, y));
    if (target.valid() && target.player != pieceInfo.player) {
      break;
    }
  }

  for (var y = pieceInfo.y - 1; y >= minY; y--) {
    var target = chessPlayGround.findTarget(pieceInfo.x, y);
    if (target.player == pieceInfo.player) {
      break;
    }

    posList.add(PosInfo(pieceInfo.x, y));
    if (target.valid() && target.player != pieceInfo.player) {
      break;
    }
  }

  return posList;
}

List<PosInfo> parsePao(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  int maxX, maxY, minX, minY;
  minX = 0;
  minY = 0;
  maxX = 8;
  maxY = 9;
  List<PosInfo> posList = [];
  for (var x = pieceInfo.x + 1, attack = false; x <= maxX; x++) {
    var target = chessPlayGround.findTarget(x, pieceInfo.y);
    if (target.valid()) {
      if (!attack) {
        attack = true;
        continue;
      } else {
        if (target.player != pieceInfo.player) {
          posList.add(PosInfo(x, pieceInfo.y));
          break;
        }
      }
    }
    if (!attack) {
      posList.add(PosInfo(x, pieceInfo.y));
    }
  }
  for (var x = pieceInfo.x - 1, attack = false; x >= minX; x--) {
    var target = chessPlayGround.findTarget(x, pieceInfo.y);
    if (target.valid()) {
      if (!attack) {
        attack = true;
        continue;
      } else {
        if (target.player != pieceInfo.player) {
          posList.add(PosInfo(x, pieceInfo.y));
          break;
        }
      }
    }
    if (!attack) {
      posList.add(PosInfo(x, pieceInfo.y));
    }
  }
  for (var y = pieceInfo.y + 1, attack = false; y <= maxY; y++) {
    var target = chessPlayGround.findTarget(pieceInfo.x, y);
    if (target.valid()) {
      if (!attack) {
        attack = true;
        continue;
      } else {
        if (target.player != pieceInfo.player) {
          posList.add(PosInfo(pieceInfo.x, y));
          break;
        }
      }
    }
    if (!attack) {
      posList.add(PosInfo(pieceInfo.x, y));
    }
  }

  for (var y = pieceInfo.y - 1, attack = false; y >= minY; y--) {
    var target = chessPlayGround.findTarget(pieceInfo.x, y);
    if (target.valid()) {
      if (!attack) {
        attack = true;
        continue;
      } else {
        if (target.player != pieceInfo.player) {
          posList.add(PosInfo(pieceInfo.x, y));
          break;
        }
      }
    }
    if (!attack) {
      posList.add(PosInfo(pieceInfo.x, y));
    }
  }

  return posList;
}

List<PosInfo> parseZu(PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  bool checkPassRiver(PieceInfo pieceInfo) {
    if (pieceInfo.player == 1) {
      if (pieceInfo.y >= 5) {
        return true;
      } else {
        return false;
      }
    } else {
      if (pieceInfo.y <= 4) {
        return true;
      } else {
        return false;
      }
    }
  }

  int maxX, maxY, minX, minY;
  minX = 0;
  minY = 0;
  maxX = 8;
  maxY = 9;
  List<PosInfo> posList = [
    PosInfo(pieceInfo.x, pieceInfo.y + ((pieceInfo.player == 1) ? (1) : (-1))),
  ];

  if (checkPassRiver(pieceInfo)) {
    posList.add(PosInfo(pieceInfo.x - 1, pieceInfo.y));
    posList.add(PosInfo(pieceInfo.x + 1, pieceInfo.y));
  }

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
