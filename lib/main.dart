// ignore_for_file: dead_code

import 'discover_china/widget/dijkstra_test_page.dart';
import 'package:flutter/material.dart';

import 'chess/chess_app.dart';
import 'discover_china/widget/china_playground.dart';

void main() {
  var test = false;
  if (test) {
    runApp(DijkstraTest());
  } else {
    if (true) {
      runApp(const DiscoverApp());
    } else {
      runApp(const ChessApp());
    }
  }
}
