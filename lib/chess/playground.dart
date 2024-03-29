import 'package:flutter/material.dart';

import 'piece_regular.dart';

const pieceBackground = Colors.brown;
const pieceBord = Colors.yellow;
const playgroundBackground = Colors.yellow;

const player1Color = Colors.red;
const player0Color = Colors.black;

const selectBordColor = Colors.green;
const targetBordColor = Colors.white;

const heightGridCount = 10;
const widthGridCount = 9;
const deadPadding = 2;

class DeadGroundMng {
  static int getX(int index) => index % widthGridCount;

  static int getY(int index) => index ~/ widthGridCount + heightGridCount;
}

class PosInfo {
  final int x;
  final int y;

  PosInfo(this.x, this.y);
}

List<PosInfo> defaultTarget(
    PieceInfo pieceInfo, ChessPlayGround chessPlayGround) {
  return List.empty();
}

enum PieceRole {
  none(parseTarget: defaultTarget, name1: ""),
  jiang(parseTarget: parseShuai, name1: "将"),
  shi(parseTarget: parseShi, name1: "士"),
  xiang(parseTarget: parseXiang, name1: "相"),
  ma(parseTarget: parseMa, name1: "马"),
  ju(parseTarget: parseJu, name1: "车"),
  pao(parseTarget: parsePao, name1: "炮"),
  zu(parseTarget: parseZu, name1: "卒");

  const PieceRole({required this.parseTarget, required this.name1});

  final String name1;

  final List<PosInfo> Function(
      PieceInfo pieceInfo, ChessPlayGround chessPlayGround) parseTarget;
}

class PieceInfo {
  int x;
  int y;
  int diffX;
  int diffY;

  bool selected;
  String text;
  int player;
  PieceRole role;

  bool maMove;

  // List<PosInfo> Function(PieceInfo pieceInfo, ChessPlayGround chessPlayGround)
  //     parseTarget;

  late Animation<double> animation;
  late AnimationController controller;

  PieceInfo(
      {required this.x,
      required this.y,
      this.diffX = 0,
      this.diffY = 0,
      required this.role,
      required this.text,
      required this.player,
      this.selected = false,
      // this.parseTarget = defaultTarget,
      this.maMove = false});

  PieceInfo clone() {
    return PieceInfo(
      x: x,
      y: y,
      role: role,
      text: text,
      player: player,
    );
  }

  bool valid() {
    return x >= 0;
  }

  void select() {
    selected = true;
  }

  void diselect() {
    selected = false;
  }

  void dead(int x, y) {
    this.x = x;
    this.y = y;
  }

  void move(int x, int y) {
    if (maMove) {
      _maMove(x, y);
      return;
    }
    diffX = x - this.x;
    diffY = y - this.y;
    listener(status) {
      if (status == AnimationStatus.completed) {
        this.x = x;
        this.y = y;
        controller.reset();
        controller.removeStatusListener(listener);
      }
    }

    controller.addStatusListener(listener);
    controller.forward();
  }

  /// support two move stag for MA piece
  void _maMove(int x, int y) {
    int tmpDiffX = x - this.x;
    int tmpDiffY = y - this.y;
    List<PosInfo> movePath = [];
    if (tmpDiffX == 2 || tmpDiffX == -2) {
      movePath.add(PosInfo(tmpDiffX ~/ 2, 0));
      movePath.add(PosInfo(tmpDiffX ~/ 2, tmpDiffY));
    } else {
      movePath.add(PosInfo(0, tmpDiffY ~/ 2));
      movePath.add(PosInfo(tmpDiffX, tmpDiffY ~/ 2));
    }

    void listener1(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        this.x = this.x + diffX;
        this.y = this.y + diffY;
        controller.reset();
        controller.removeStatusListener(listener1);
      }
    }

    void listener0(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        this.x = this.x + diffX;
        this.y = this.y + diffY;
        controller.reset();
        controller.removeStatusListener(listener0);

        diffX = movePath[1].x;
        diffY = movePath[1].y;
        controller.addStatusListener(listener1);
        controller.forward();
      }
    }

    diffX = movePath[0].x;
    diffY = movePath[0].y;
    controller.addStatusListener(listener0);
    controller.forward();
  }
}

class ChessPlayGround {
  List<PieceInfo> getPieceList() => _pieceList;
  List<PosInfo> getParseTargetList() => _parseTargetList;

  List<PosInfo> _parseTargetList = [];

  ChessPlayGround(List<PieceInfo> pieceList) {
    _pieceList = pieceList;
  }

  ChessPlayGround.clone(ChessPlayGround chessPlayGround) {
    _pieceList = chessPlayGround._clonePieceList();
  }

  int playerTurn = 1;

  late final List<PieceInfo> _pieceList;

  PieceInfo findTarget(int x, y) {
    var target = _pieceList.firstWhere(
        (element) => element.x == x && element.y == y,
        orElse: () => PieceInfo(
            x: -1, y: -1, text: "", player: -1, role: PieceRole.none));
    return target;
  }

  PieceInfo findTargetByGivenPieceList(List<PieceInfo> pieceList, int x, y) {
    var target = pieceList.firstWhere(
        (element) => element.x == x && element.y == y,
        orElse: () => PieceInfo(
            x: -1, y: -1, text: "", player: -1, role: PieceRole.none));
    return target;
  }

  void _select(PieceInfo pieceInfo) {
    var parseTargetList = pieceInfo.role.parseTarget(pieceInfo, this);
    _parseTargetList = parseTargetList;

    pieceInfo.select();
    selected = pieceInfo;
  }

  void _diselect() {
    if (selected != null) {
      selected?.diselect();
    }
    _parseTargetList = [];
    selected = null;
  }

  void _dead(PieceInfo target) {
    _pieceList.remove(target);
    // var index = _pieceList.indexOf(target);
    // var x = DeadGroundMng.getX(index);
    // var y = DeadGroundMng.getY(index);
    // target.dead(x, y);
  }

  bool _kill(PieceInfo target) {
    if (_checkCheckmate(selected, target.x, target.y)) {
      _diselect();
      return false;
    }
    _move(target.x, target.y);
    _dead(target);
    _diselect();
    return true;
  }

  List<PieceInfo> _clonePieceList() {
    return _pieceList.map((e) => e.clone()).toList();
  }

  bool _checkCheckmate(PieceInfo? pieceInfo, int x, int y) {
    if (pieceInfo == null) {
      return false;
    }

    var cloneChessPlayGround = ChessPlayGround.clone(this);
    var selfPieceInfo =
        cloneChessPlayGround.findTarget(pieceInfo.x, pieceInfo.y);
    var targetPieceInfo = cloneChessPlayGround.findTarget(x, y);
    if (targetPieceInfo.valid()) {
      cloneChessPlayGround._pieceList.remove(targetPieceInfo);
    }
    selfPieceInfo.x = x;
    selfPieceInfo.y = y;

    for (var element in cloneChessPlayGround._pieceList) {
      if (element.player != pieceInfo.player) {
        if (element.role.index >= PieceRole.ma.index) {
          var targets = element.role.parseTarget(element, cloneChessPlayGround);
          for (var target in targets) {
            var targetPiece =
                cloneChessPlayGround.findTarget(target.x, target.y);
            if (targetPiece.role == PieceRole.jiang &&
                targetPiece.player == pieceInfo.player) {
              return true;
            }
          }
        }
      } else if (element.role == PieceRole.jiang) {
        var diffY = 3 - element.player * 2;
        for (int i = 1;
            element.y + diffY * i <= 9 && element.y + diffY * i >= 0;
            i++) {
          var target =
              cloneChessPlayGround.findTarget(element.x, element.y + diffY * i);
          if (target.valid()) {
            if (target.player != element.player &&
                target.role == PieceRole.jiang) {
              return true;
            } else {
              break;
            }
          }
        }
      }
    }

    return false;
  }

  bool _move(int x, y) {
    if (_checkCheckmate(selected, x, y)) {
      _diselect();
      return false;
    }

    selected?.move(x, y);
    _diselect();
    return true;
  }

  void _changeSelect(PieceInfo target) {
    _diselect();
    _select(target);
  }

  PieceInfo? selected;

  bool _checkInParseTargetTist(int x, int y) =>
      _parseTargetList.any((e) => e.x == x && e.y == y);

  void processEvent(int x, y) {
    if (selected != null) {
      var target = findTarget(x, y);
      if (target.valid()) {
        if (target.player != selected?.player &&
            _checkInParseTargetTist(x, y)) {
          if (_kill(target)) {
            playerTurn = 3 - playerTurn;
          }
        } else if (target == selected) {
          _diselect();
        } else if (target.player == playerTurn) {
          _changeSelect(target);
        }
      } else {
        if (_checkInParseTargetTist(x, y)) {
          if (_move(x, y)) {
            playerTurn = 3 - playerTurn;
          }
        }
      }
    } else {
      for (var element in chessPlayGround.getPieceList()) {
        if (element.x == x && element.y == y && playerTurn == element.player) {
          _select(element);
        } else {
          element.diselect();
        }
      }
    }
  }
}

var chessPlayGround = ChessPlayGround(classicPieceList);

final classicPieceList = [
  PieceInfo(
      x: 0,
      y: 0,
      text: "车",
      player: 1,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 0,
      text: "马",
      player: 1,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 2,
      y: 0,
      text: "相",
      player: 1,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 3,
      y: 0,
      text: "仕",
      player: 1,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 4,
      y: 0,
      text: "帅",
      player: 1,
      // parseTarget: parseShuai,
      role: PieceRole.jiang),
  PieceInfo(
      x: 5,
      y: 0,
      text: "仕",
      player: 1,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 6,
      y: 0,
      text: "相",
      player: 1,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 7,
      y: 0,
      text: "马",
      player: 1,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 8,
      y: 0,
      text: "车",
      player: 1,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 2,
      text: "炮",
      player: 1,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 7,
      y: 2,
      text: "炮",
      player: 1,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 0,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 2,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 4,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 6,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 8,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  //
  PieceInfo(
      x: 0,
      y: 9,
      text: "车",
      player: 2,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 9,
      text: "马",
      player: 2,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 2,
      y: 9,
      text: "相",
      player: 2,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 3,
      y: 9,
      text: "仕",
      player: 2,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 4,
      y: 9,
      text: "帅",
      player: 2,
      // parseTarget: parseShuai,
      role: PieceRole.jiang),
  PieceInfo(
      x: 5,
      y: 9,
      text: "仕",
      player: 2,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 6,
      y: 9,
      text: "相",
      player: 2,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 7,
      y: 9,
      text: "马",
      player: 2,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 8,
      y: 9,
      text: "车",
      player: 2,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 7,
      text: "炮",
      player: 2,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 7,
      y: 7,
      text: "炮",
      player: 2,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 0,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 2,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 4,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 6,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 8,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
];

final testPieceList = [
  PieceInfo(
      x: 0,
      y: 0,
      text: "车",
      player: 1,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 0,
      text: "马",
      player: 1,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 2,
      y: 0,
      text: "相",
      player: 1,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 3,
      y: 0,
      text: "仕",
      player: 1,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 4,
      y: 0,
      text: "帅",
      player: 1,
      // parseTarget: parseShuai,
      role: PieceRole.jiang),
  PieceInfo(
      x: 5,
      y: 0,
      text: "仕",
      player: 1,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 6,
      y: 0,
      text: "相",
      player: 1,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 7,
      y: 0,
      text: "马",
      player: 1,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 8,
      y: 0,
      text: "车",
      player: 1,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 2,
      text: "炮",
      player: 1,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 7,
      y: 2,
      text: "炮",
      player: 1,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 0,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 2,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  // PieceInfo(
  //     x: 4,
  //     y: 3,
  //     text: "兵",
  //     player: 1,
  //     parseTarget: parseZu,
  //     role: PieceInfo.zu),
  PieceInfo(
      x: 6,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 8,
      y: 3,
      text: "兵",
      player: 1,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  //
  PieceInfo(
      x: 0,
      y: 9,
      text: "车",
      player: 2,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 9,
      text: "马",
      player: 2,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 2,
      y: 9,
      text: "相",
      player: 2,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 3,
      y: 9,
      text: "仕",
      player: 2,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 4,
      y: 9,
      text: "帅",
      player: 2,
      // parseTarget: parseShuai,
      role: PieceRole.jiang),
  PieceInfo(
      x: 5,
      y: 9,
      text: "仕",
      player: 2,
      // parseTarget: parseShi,
      role: PieceRole.shi),
  PieceInfo(
      x: 6,
      y: 9,
      text: "相",
      player: 2,
      // parseTarget: parseXiang,
      role: PieceRole.xiang),
  PieceInfo(
      x: 7,
      y: 9,
      text: "马",
      player: 2,
      // parseTarget: parseMa,
      maMove: true,
      role: PieceRole.ma),
  PieceInfo(
      x: 8,
      y: 9,
      text: "车",
      player: 2,
      // parseTarget: parseJu,
      role: PieceRole.ju),
  PieceInfo(
      x: 1,
      y: 7,
      text: "炮",
      player: 2,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 4,
      y: 7,
      text: "炮",
      player: 2,
      // parseTarget: parsePao,
      role: PieceRole.pao),
  PieceInfo(
      x: 0,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 2,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  // PieceInfo(
  //     x: 4,
  //     y: 6,
  //     text: "兵",
  //     player: 2,
  //     parseTarget: parseZu,
  //     role: PieceInfo.zu),
  PieceInfo(
      x: 6,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
  PieceInfo(
      x: 8,
      y: 6,
      text: "兵",
      player: 2,
      // parseTarget: parseZu,
      role: PieceRole.zu),
];
