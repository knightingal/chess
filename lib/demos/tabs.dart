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

  @override
  void paint1(PaintingContext context, Offset offset) {
    developer.log("get offset ${offset.dx}");

    // context.canvas.drawRect(
    //     offset & size,
    //     Paint()
    //       ..color = Colors.yellow
    //       ..strokeWidth = 2
    //       ..style = PaintingStyle.stroke);

    Rect rect = offset & size;
    // Rect tRect =
    //     Rect.fromLTRB(rect.left + 40, rect.top, rect.right - 40, rect.bottom);
    // context.canvas.drawRect(tRect, Paint()..color = color);

    // Rect arcRect = Rect.fromLTWH(rect.left - 40, rect.top, 80, 80);

    // Path path = Path()
    //   ..moveTo(rect.left, rect.top)
    //   ..lineTo(rect.left + 40, rect.top)
    //   ..lineTo(rect.left + 40, rect.top + 40)
    //   ..arcTo(arcRect, 0, -pi / 2, true);
    // // ..close();
    // context.canvas.drawPath(
    //     path,
    //     Paint()
    //       ..color = color
    //       ..style = PaintingStyle.fill);

    // arcRect = Rect.fromLTWH(rect.right - 80, rect.top, 80, 80);

    // path = Path()
    //   ..moveTo(rect.right - 40, rect.top)
    //   ..arcTo(arcRect, 0, -pi / 2, true)
    //   ..lineTo(rect.right - 40, rect.top + 40)
    //   ..close();
    // context.canvas.drawPath(path, Paint()..color = color);

    Rect rRect = Rect.fromLTRB(
        rect.left + 15, rect.top, rect.right - 15, rect.bottom - 5);
    context.canvas.drawRect(rRect, Paint()..color = Colors.red);

    Rect arcRectLeft = Rect.fromLTWH(rect.left + 5, rect.top, 10, 10);
    Path arcRectLeftPath = Path()
      ..moveTo(rect.left + 10, rect.top)
      ..lineTo(rect.left + 15, rect.top)
      ..lineTo(rect.left + 15, rect.top + 5)
      ..arcTo(arcRectLeft, 0, -pi / 2, true);
    context.canvas.drawPath(
        arcRectLeftPath,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill);

    Rect arcRectRight = Rect.fromLTWH(rect.right - 15, rect.top, 10, 10);
    Path arcRectLeftRight = Path()
      ..moveTo(rect.right - 10, rect.top)
      ..lineTo(rect.right - 15, rect.top)
      ..lineTo(rect.right - 15, rect.top + 5)
      ..arcTo(arcRectRight, pi, pi / 2, true);
    context.canvas.drawPath(
        arcRectLeftRight,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill);

    Rect arcRectLeftButton =
        Rect.fromLTWH(rect.left + 15, rect.bottom - 10, 10, 10);
    Path arcRectLeftButtonPath = Path()
      ..moveTo(rect.left + 15, rect.bottom - 5)
      ..lineTo(rect.left + 20, rect.bottom - 5)
      ..lineTo(rect.left + 20, rect.bottom)
      ..arcTo(arcRectLeftButton, pi / 2, pi / 2, true);
    context.canvas.drawPath(
        arcRectLeftButtonPath,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill);

    Rect arcRectRightButton =
        Rect.fromLTWH(rect.right - 25, rect.bottom - 10, 10, 10);
    Path arcRectRightButtonPath = Path()
      ..moveTo(rect.right - 15, rect.bottom - 5)
      ..lineTo(rect.right - 20, rect.bottom - 5)
      ..lineTo(rect.right - 20, rect.bottom)
      ..arcTo(arcRectRightButton, pi / 2, -pi / 2, true);
    context.canvas.drawPath(
        arcRectRightButtonPath,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill);
    context.canvas.drawRect(
        Rect.fromLTRB(
            rect.left + 20, rect.bottom - 5, rect.right - 20, rect.bottom),
        Paint()..color = Colors.red);
  }
}
