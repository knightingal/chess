import 'package:flutter/widgets.dart';

const heightGridCount = 10;
const widthGridCount = 9;
const deadPadding = 2;

class DeadGroundMng {
  static int getX(int index) => index % widthGridCount;

  static int getY(int index) => index ~/ widthGridCount + heightGridCount;
}

class PieceInfo {
  int x;
  int y;
  bool selected;
  String text;
  int player;

  late Animation<double> animation;
  late AnimationController controller;

  PieceInfo(
      {required this.x,
      required this.y,
      required this.text,
      required this.player,
      this.selected = false});

  bool valid() {
    return x >= 0;
  }

  void select() {
    selected = true;
  }

  void diselect() {
    selected = false;
  }

  void move(int x, y) {
    this.x = x;
    this.y = y;
  }
}

class ChessPlayGround {
  List<PieceInfo> getPieceList() => _pieceList;

  final List<PieceInfo> _pieceList = [
    PieceInfo(x: 0, y: 0, text: "车", player: 1),
    PieceInfo(x: 1, y: 0, text: "马", player: 1),
    PieceInfo(x: 2, y: 0, text: "相", player: 1),
    PieceInfo(x: 3, y: 0, text: "仕", player: 1),
    PieceInfo(x: 4, y: 0, text: "帅", player: 1),
    PieceInfo(x: 5, y: 0, text: "仕", player: 1),
    PieceInfo(x: 6, y: 0, text: "相", player: 1),
    PieceInfo(x: 7, y: 0, text: "马", player: 1),
    PieceInfo(x: 8, y: 0, text: "车", player: 1),
    PieceInfo(x: 1, y: 2, text: "炮", player: 1),
    PieceInfo(x: 7, y: 2, text: "炮", player: 1),
    PieceInfo(x: 0, y: 3, text: "兵", player: 1),
    PieceInfo(x: 2, y: 3, text: "兵", player: 1),
    PieceInfo(x: 4, y: 3, text: "兵", player: 1),
    PieceInfo(x: 6, y: 3, text: "兵", player: 1),
    PieceInfo(x: 8, y: 3, text: "兵", player: 1),
    //
    PieceInfo(x: 0, y: 9, text: "车", player: 2),
    PieceInfo(x: 1, y: 9, text: "马", player: 2),
    PieceInfo(x: 2, y: 9, text: "相", player: 2),
    PieceInfo(x: 3, y: 9, text: "仕", player: 2),
    PieceInfo(x: 4, y: 9, text: "帅", player: 2),
    PieceInfo(x: 5, y: 9, text: "仕", player: 2),
    PieceInfo(x: 6, y: 9, text: "相", player: 2),
    PieceInfo(x: 7, y: 9, text: "马", player: 2),
    PieceInfo(x: 8, y: 9, text: "车", player: 2),
    PieceInfo(x: 1, y: 7, text: "炮", player: 2),
    PieceInfo(x: 7, y: 7, text: "炮", player: 2),
    PieceInfo(x: 0, y: 6, text: "兵", player: 2),
    PieceInfo(x: 2, y: 6, text: "兵", player: 2),
    PieceInfo(x: 4, y: 6, text: "兵", player: 2),
    PieceInfo(x: 6, y: 6, text: "兵", player: 2),
    PieceInfo(x: 8, y: 6, text: "兵", player: 2),
  ];

  PieceInfo _findTarget(int x, y) {
    var target = _pieceList.firstWhere(
        (element) => element.x == x && element.y == y,
        orElse: () => PieceInfo(x: -1, y: -1, text: "", player: -1));
    return target;
  }

  void _select(PieceInfo pieceInfo) {
    pieceInfo.select();
    selected = pieceInfo;
  }

  void _diselect() {
    if (selected != null) {
      selected?.diselect();
    }
    selected = null;
  }

  void _dead(PieceInfo target) {
    var index = _pieceList.indexOf(target);
    var x = DeadGroundMng.getX(index);
    var y = DeadGroundMng.getY(index);
    target.move(x, y);
  }

  void _kill(PieceInfo target) {
    _move(target.x, target.y);
    _dead(target);
    _diselect();
  }

  void _move(int x, y) {
    selected?.move(x, y);
    _diselect();
  }

  void _changeSelect(PieceInfo target) {
    _diselect();
    _select(target);
  }

  PieceInfo? selected;

  void processEvent(int x, y) {
    if (selected != null) {
      var target = _findTarget(x, y);
      if (target.valid()) {
        if (target.player != selected?.player) {
          _kill(target);
        } else if (target == selected) {
          _diselect();
        } else {
          _changeSelect(target);
        }
      } else {
        _move(x, y);
      }
    } else {
      for (var element in chessPlayGround.getPieceList()) {
        if (element.x == x && element.y == y) {
          _select(element);
        } else {
          element.diselect();
        }
      }
    }
  }
}

var chessPlayGround = ChessPlayGround();
