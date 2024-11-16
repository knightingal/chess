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
          TabBox(color: Colors.green),
          TabBox(color: Colors.green),
          TabBox(color: Colors.green),
          TabBox(color: Colors.green),
          TabBox(color: Colors.green),
        ],
      ),
    );
  }
}

const double tabWidth = 160;
const double tabIndent = 30;

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
  const TabBox({required this.color, super.child, super.key});

  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TabBox(color: color);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _TabBox).color = color;
  }
}

class _TabBox extends RenderProxyBoxWithHitTestBehavior {
  _TabBox({required Color color})
      : _color = color,
        super(behavior: HitTestBehavior.opaque);

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = const Size(tabWidth, 40);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    developer.log("get offset ${offset.dx}");

    // context.canvas.drawRect(
    //     offset & size,
    //     Paint()
    //       ..color = Colors.yellow
    //       ..strokeWidth = 2
    //       ..style = PaintingStyle.stroke);

    Rect rect = offset & size;
    Rect tRect =
        Rect.fromLTRB(rect.left + 40, rect.top, rect.right - 40, rect.bottom);
    context.canvas.drawRect(tRect, Paint()..color = color);

    Rect arcRect = Rect.fromLTWH(rect.left - 40, rect.top, 80, 80);

    Path path = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + 40, rect.top)
      ..lineTo(rect.left + 40, rect.top + 40)
      ..arcTo(arcRect, 0, -pi / 2, true);
    // ..close();
    context.canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);

    arcRect = Rect.fromLTWH(rect.right - 80, rect.top, 80, 80);

    path = Path()
      ..moveTo(rect.right - 40, rect.top)
      ..arcTo(arcRect, 0, -pi / 2, true)
      ..lineTo(rect.right - 40, rect.top + 40)
      ..close();
    context.canvas.drawPath(path, Paint()..color = color);
  }
}
