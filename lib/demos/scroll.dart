import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/rendering/sliver_multi_box_adaptor.dart';

/// Flutter code sample for [CustomScrollView].

// void main() => runApp(const CustomScrollViewExampleApp());

class CustomScrollViewExampleApp extends StatelessWidget {
  const CustomScrollViewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomScrollViewExample(),
    );
  }
}

class CustomScrollViewExample extends StatefulWidget {
  const CustomScrollViewExample({super.key});

  @override
  State<CustomScrollViewExample> createState() =>
      _CustomScrollViewExampleState();
}

class _CustomScrollViewExampleState extends State<CustomScrollViewExample> {
  List<int> top = <int>[];
  List<int> bottom = <int>[0, 1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Press on the plus to add items above and below'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              top.add(-top.length - 1);
              bottom.add(bottom.length);
            });
          },
        ),
      ),
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         alignment: Alignment.center,
          //         color: Colors.blue[200 + top[index] % 4 * 100],
          //         height: 100 + top[index] % 4 * 20.0,
          //         child: Text('Item: ${top[index]}'),
          //       );
          //     },
          //     childCount: top.length,
          //   ),
          // ),

          // SliverList(
          //   key: centerKey,
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         alignment: Alignment.center,
          //         color: Colors.blue[200 + bottom[index] % 4 * 100],
          //         height: 100 + bottom[index] % 4 * 20.0,
          //         child: Text('Item: ${bottom[index]}'),
          //       );
          //     },
          //     childCount: bottom.length,
          //   ),
          // ),

          SliverWaterFall(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.blue[200 + bottom[index] % 4 * 100],
                  height: 100 ,
                  width: 100,
                  child: Text('Item: ${bottom[index]}'),
                );
              },
              childCount: bottom.length,
            ),
          )


        ],
      ),
    );
  }
}

class SliverWaterFall extends SliverMultiBoxAdaptorWidget {
  const SliverWaterFall({super.key, required super.delegate});

  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverWaterFall(childManager: element);
  }

}

class RenderSliverWaterFall extends RenderSliverMultiBoxAdaptor {
  RenderSliverWaterFall({required super.childManager});
  
  @override
  void performLayout() {
    // TODO: implement performLayout
    final SliverConstraints constraints = this.constraints;
    log("constraints.scrollOffset:${constraints.toString()}");
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final BoxConstraints tmpConstraints = constraints.asBoxConstraints();
    final BoxConstraints childConstraints = BoxConstraints(
      minWidth: 0,
      minHeight: tmpConstraints.minHeight,
      maxWidth: tmpConstraints.maxWidth,
      maxHeight: tmpConstraints.maxHeight,
    );

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }
    firstChild!.layout(childConstraints, parentUsesSize: true);

    SliverMultiBoxAdaptorParentData childParentData = firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
    childParentData.layoutOffset = 0;
    childParentData.index = 0;
    

    RenderBox? earliestUsefulChild = firstChild;
    RenderBox? current;
    double layoutOffset = 100;
    int index = 1;

    while (true) {

      current = childAfter(earliestUsefulChild!);
      if (current == null) {
        current = insertAndLayoutChild(childConstraints, after: earliestUsefulChild, parentUsesSize: true);
        if (current == null) {
          break;
        }
      } else {
        current.layout(childConstraints, parentUsesSize: true);
      }
      childParentData = current.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = layoutOffset;
      childParentData.index = index;
      earliestUsefulChild = current;
      layoutOffset += 100;
      index += 1;
    }
    log("message");

    double totalHeight = layoutOffset;
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: totalHeight,
    );

    geometry = SliverGeometry(
      scrollExtent: totalHeight,
      paintExtent: paintExtent,
      cacheExtent: totalHeight,
      maxPaintExtent: totalHeight,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: constraints.remainingPaintExtent < totalHeight,
    );
  }
  
}