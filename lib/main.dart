// ignore_for_file: dead_code

import 'package:flutter/material.dart';

import 'chess/chess_app.dart';
import 'discover_china/widget/china_playground.dart'
    hide heightGridCount, widthGridCount;

void main() {
  if (true) {
    runApp(const DiscoverApp());
  } else {
    runApp(const ChessApp());
  }
}
