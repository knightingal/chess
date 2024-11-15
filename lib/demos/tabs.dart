import 'package:flutter/material.dart';

class TabsApp extends StatelessWidget {
  const TabsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "tabs",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TabsMain(),
    );
  }
}

class TabsMain extends StatelessWidget {
  const TabsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("tabs"),
    );
  }
}
