import 'dart:developer' as developer;

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
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: const TabsBox(
              children: [
                TabBox(main: true),
                TabBox(main: false),
                TabBox(main: false),
                TabBox(main: false),
                TabBox(main: false),
              ],
            ),
          ),
          Container(
            height: 150,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

const double tabWidth = 240;
const double tabIndent = 15;
const double tabDividerWidth = 5;

const double cornerRadius = 10;
const double bottomCornerRadius = 12;

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
  bool get sizedByParent => true;

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
        parentUsesSize: false,
      );

      firstChild = childParentData.nextSibling;
      i++;
    }
  }

  @override
  void performResize() {
    size = Size(constraints.maxWidth, 35);
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
  const TabBox({required this.main, super.child, super.key});

  final bool main;
  Color getColor() {
    return switch (main) {
      true => Colors.blue,
      false => Colors.blue[100]!,
    };
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TabBox(color: getColor(), main: main);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _TabBox).color = getColor();
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
      ..moveTo(rect.left + cornerRadius * 2, rect.top)
      ..arcToPoint(Offset(rect.left + cornerRadius, rect.top + cornerRadius),
          radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(rect.left + cornerRadius,
          rect.bottom - cornerRadius - tabDividerWidth)
      ..arcToPoint(
          Offset(rect.left + cornerRadius * 2, rect.bottom - tabDividerWidth),
          radius: const Radius.circular(cornerRadius),
          clockwise: false)
      ..lineTo(rect.right - cornerRadius * 2, rect.bottom - tabDividerWidth)
      ..arcToPoint(
          Offset(rect.right - cornerRadius,
              rect.bottom - tabDividerWidth - cornerRadius),
          radius: const Radius.circular(cornerRadius),
          clockwise: false)
      ..lineTo(rect.right - cornerRadius, rect.top + cornerRadius)
      ..arcToPoint(Offset(rect.right - cornerRadius * 2, rect.top),
          radius: const Radius.circular(cornerRadius), clockwise: false)
      ..close();
    return path;
  }

  Path mainPath(Rect rect) {
    Path path = Path()
      ..moveTo(rect.left - 2, rect.bottom)
      ..arcToPoint(
          Offset(rect.left + cornerRadius, rect.bottom - bottomCornerRadius),
          radius: const Radius.circular(bottomCornerRadius),
          clockwise: false)
      ..lineTo(rect.left + cornerRadius, rect.top + cornerRadius)
      ..arcToPoint(Offset(rect.left + cornerRadius * 2, rect.top),
          radius: const Radius.circular(cornerRadius), clockwise: true)
      ..lineTo(rect.right - cornerRadius * 2, rect.top)
      ..arcToPoint(Offset(rect.right - cornerRadius, rect.top + cornerRadius),
          radius: const Radius.circular(cornerRadius), clockwise: true)
      ..lineTo(rect.right - cornerRadius, rect.bottom - bottomCornerRadius)
      ..arcToPoint(Offset(rect.right + 2, rect.bottom),
          radius: const Radius.circular(bottomCornerRadius), clockwise: false)
      ..close();
    return path;
  }
}
