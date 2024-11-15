// ignore_for_file: dead_code

import 'package:chess/demos/tabs.dart';

import 'discover_china/widget/dijkstra_test_page.dart';
import 'package:flutter/material.dart';

import 'chess/chess_app.dart';
import 'discover_china/widget/china_playground.dart';

void main() {
  var test = false;
  var tabs = true;
  if (tabs) {
    runApp(const TabsApp());
  } else {
    if (test) {
      runApp(const DijkstraTest());
    } else {
      if (true) {
        runApp(const DiscoverApp());
      } else {
        runApp(const ChessApp());
      }
    }
  }
}
