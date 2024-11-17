import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      body: TabsBox(
        children: [
          TabBox(color: Colors.green, main: true),
          TabBox(color: Colors.green, main: false),
          TabBox(color: Colors.green, main: false),
          TabBox(color: Colors.green, main: true),
          TabBox(color: Colors.green, main: false),
        ],
      ),
    );
  }
}

const double tabWidth = 160;
const double tabIndent = 15;

const double edgeRadius = 10;

class TabsBox extends MultiChildRenderObjectWidget {
  const TabsBox({Key? key, required List<Widget> children})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTabs();
  }
}

class TabsParentData extends ContainerBoxParentData<RenderBox> {}

class RenderTabs extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TabsParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TabsParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! TabsParentData) {
      child.parentData = TabsParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    RenderBox? firstChild;
    int i = 0;
    firstChild = this.firstChild;
    while (firstChild != null) {
      developer.log("layout $i");
      TabsParentData childParentData = firstChild.parentData as TabsParentData;
      childParentData.offset = Offset(i * (tabWidth - tabIndent), 0);

      firstChild.layout(
        constraints.copyWith(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );

      firstChild = childParentData.nextSibling;
      i++;
    }

    size = Size(i * (tabWidth - tabIndent) + tabIndent, 40);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class TabBox extends SingleChildRenderObjectWidget {
  const TabBox(
      {required this.color, required this.main, super.child, super.key});

  final Color color;
  final bool main;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TabBox(color: color, main: main);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _TabBox).color = color;
  }
}

class _TabBox extends RenderProxyBoxWithHitTestBehavior {
  _TabBox({required Color color, required bool main})
      : _color = color,
        _main = main,
        super(behavior: HitTestBehavior.opaque);

  Color get color => _color;
  Color _color;
  final bool _main;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = const Size(tabWidth, 35);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Rect rect = offset & size;
    // context.canvas.drawRect(
    //     rect,
    //     Paint()
    //       ..color = Colors.yellow
    //       ..style = PaintingStyle.stroke);
    Path path = switch (_main) {
      true => mainPath(rect),
      false => inactivePath(rect),
    };

    context.canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  Path inactivePath(Rect rect) {
    Path path = Path()
      ..moveTo(rect.left + edgeRadius * 2, rect.top + 5)
      ..arcToPoint(Offset(rect.left + edgeRadius, rect.top + 5 + edgeRadius),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..lineTo(rect.left + edgeRadius, rect.bottom - edgeRadius)
      ..arcToPoint(Offset(rect.left + edgeRadius * 2, rect.bottom),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..lineTo(rect.right - edgeRadius * 2, rect.bottom)
      ..arcToPoint(Offset(rect.right - edgeRadius, rect.bottom - edgeRadius),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..lineTo(rect.right - edgeRadius, rect.top + 5 + edgeRadius)
      ..arcToPoint(Offset(rect.right - edgeRadius * 2, rect.top + 5),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..close();
    return path;
  }

  Path mainPath(Rect rect) {
    Path path = Path()
      ..moveTo(rect.left, rect.top)
      ..arcToPoint(Offset(rect.left + edgeRadius, rect.top + edgeRadius),
          radius: const Radius.circular(edgeRadius), clockwise: true)
      ..lineTo(rect.left + edgeRadius, rect.bottom - edgeRadius)
      ..arcToPoint(Offset(rect.left + edgeRadius * 2, rect.bottom),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..lineTo(rect.right - edgeRadius * 2, rect.bottom)
      ..arcToPoint(Offset(rect.right - edgeRadius, rect.bottom - edgeRadius),
          radius: const Radius.circular(edgeRadius), clockwise: false)
      ..lineTo(rect.right - edgeRadius, rect.top + edgeRadius)
      ..arcToPoint(Offset(rect.right, rect.top),
          radius: const Radius.circular(edgeRadius), clockwise: true)
      ..close();
    return path;
  }
}
