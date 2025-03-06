import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  // List<int> bottom = <int>[
  //   // dart format off
  //   0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
  //   10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  //   20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
  //   30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  //   40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
  //   50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
  //   60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
  //   // dart format on
  // ];

  int totalLength = 1000;


  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    for (int i = 0; i < totalLength; i++) {
      int slotIndex = minSlot(slot);
      Slot slotOne = slot[slotIndex];
      slotOne.slotItemList
          .add(SlotItem(i, slotOne.totalHeight, 100 + i % 4 * 20.0, slotIndex));
      slotOne.totalHeight = slotOne.totalHeight + 100 + i % 4 * 20.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Press on the plus to add items above and below'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              top.add(-top.length - 1);
              totalLength++;
              // bottom.add(bottom.length);
            });
          },
        ),
      ),
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          SliverWaterFall(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.grey[200 + bottom[index] % 4 * 100],
                  height: 100 + index % 4 * 20.0,
                  // height: 100 ,
                  width: 0,
                  child: Text('Item: $index'),
                );
              },
              childCount: totalLength,
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
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSliverWaterFall(childManager: element);
  }
}

class _RenderSliverWaterFallParentData extends SliverMultiBoxAdaptorParentData {
  double? crossOffSet;
}

class SlotItem {
  final int index;
  final double scrollOffset;
  final double itemHeight;
  final int slotIndex;

  SlotItem(this.index, this.scrollOffset, this.itemHeight, this.slotIndex);
}

class Slot {
  final List<SlotItem> slotItemList = [];
  double totalHeight = 0;

  SlotItem itemByIndex(int index) {
    return slotItemList.firstWhere((item) {
      return item.index == index;
    });
  }

  bool existByIndex(int index) {
    return slotItemList.any((item) => item.index == index);
  }
}

int minSlot(List<Slot> slot) {
  double min = slot[0].totalHeight;
  int index = 0;
  for (int i = 0; i < 4; i++) {
    if (slot[i].totalHeight < min) {
      min = slot[i].totalHeight;
      index = i;
    }
  }
  return index;
}

int maxSlotByRenderIndex(List<Slot> slot, int renderIndex) {
  double maxHeight = 0;
  int maxIndex = 0;
  for (int i = 0; i <= renderIndex; i++) {
    SlotItem item = findSlotByIndex(slot, i)!;
    if (item.scrollOffset + item.itemHeight > maxHeight) {
      maxHeight = item.scrollOffset + item.itemHeight;
      maxIndex = i;
    }
  }
  return maxIndex;
}

int maxSlot(List<Slot> slot) {
  double max = 0;
  int index = 5;
  for (int i = 0; i < 4; i++) {
    if (slot[i].totalHeight > max) {
      max = slot[i].totalHeight;
      index = i;
    }
  }
  return index;
}

SlotItem? findSlotByIndex(List<Slot> slot, int index) {
  for (int i = 0; i < 4; i++) {
    if (slot[i].existByIndex(index)) {
      return slot[i].itemByIndex(index);
    }
  }
  return null;
}

List<Slot> slot = [Slot(), Slot(), Slot(), Slot()];

class RenderSliverWaterFall extends RenderSliverMultiBoxAdaptor {
  RenderSliverWaterFall({required super.childManager});

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _RenderSliverWaterFallParentData) {
      child.parentData = _RenderSliverWaterFallParentData();
      (child.parentData as _RenderSliverWaterFallParentData).crossOffSet = 0;
    }
  }

  @override
  double childCrossAxisPosition(covariant RenderObject child) {
    return (child.parentData as _RenderSliverWaterFallParentData).crossOffSet!;
  }

  @override
  void performLayout() {
    log("enter performLayout()");
    List<double> slotHeight = [0, 0, 0, 0];
    double minSlotHeight() {
      double min = slotHeight[0];
      for (int i = 0; i < slotHeight.length; i++) {
        if (slotHeight[i] < min) {
          min = slotHeight[i];
        }
      }
      return min;
    }

    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    // final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    final double scrollOffset = constraints.scrollOffset + 200;
    log("scrollOffset:$scrollOffset, constraints.scrollOffset:${constraints.scrollOffset}, constraints.cacheOrigin:${constraints.cacheOrigin}");
    assert(scrollOffset >= 0.0);
    // final double remainingExtent = constraints.remainingCacheExtent;
    final double remainingExtent = constraints.remainingPaintExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset =
        constraints.scrollOffset + remainingExtent - 200;
    final BoxConstraints tmpConstraints = constraints.asBoxConstraints();
    final BoxConstraints childConstraints = BoxConstraints(
      maxHeight: tmpConstraints.maxHeight,
      minHeight: tmpConstraints.minHeight,
      maxWidth: tmpConstraints.maxWidth,
      minWidth: tmpConstraints.minWidth / 4,
    );
    // int leadingGarbage = 0;
    // int trailingGarbage = 0;
    int findFirstIndex() {
      int totalLength = slot[0].slotItemList.length +
          slot[1].slotItemList.length +
          slot[2].slotItemList.length +
          slot[3].slotItemList.length;
      for (int i = 0; i < totalLength; i++) {
        SlotItem slotItem = findSlotByIndex(slot, i)!;
        if (slotItem.itemHeight + slotItem.scrollOffset > scrollOffset) {
          return i;
        }
      }
      return totalLength - 1;
    }

    int firstIndex = findFirstIndex();
    _RenderSliverWaterFallParentData childParentData;

    if (firstChild == null) {
      addInitialChild();
      firstChild!.layout(childConstraints, parentUsesSize: true);
      childParentData =
          firstChild!.parentData! as _RenderSliverWaterFallParentData;
      SlotItem? slotItem = findSlotByIndex(slot, childParentData.index!);
      childParentData.layoutOffset = slotItem!.scrollOffset;
      childParentData.crossOffSet =
          slotItem.slotIndex * tmpConstraints.minWidth / 4;
    } else if (firstIndex <
        (firstChild!.parentData! as _RenderSliverWaterFallParentData).index!) {
      while (true) {
        RenderBox? child =
            insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
        childParentData =
            child!.parentData! as _RenderSliverWaterFallParentData;
        SlotItem? slotItem = findSlotByIndex(slot, childParentData.index!);
        childParentData.layoutOffset = slotItem!.scrollOffset;
        childParentData.crossOffSet =
            slotItem.slotIndex * tmpConstraints.minWidth / 4;
        if (childParentData.index == firstIndex) {
          break;
        }
      }
    }

    RenderBox? child;
    RenderBox? lastChild = firstChild;

    while (true) {
      child = childAfter(lastChild!);
      if (child == null) {
        child = insertAndLayoutChild(childConstraints,
            after: lastChild, parentUsesSize: true);
        if (child == null) {
          break;
        }
      } else {
        child.layout(childConstraints, parentUsesSize: true);
      }
      childParentData = child.parentData! as _RenderSliverWaterFallParentData;
      SlotItem? slotItem = findSlotByIndex(slot, childParentData.index!);
      childParentData.layoutOffset = slotItem!.scrollOffset;
      childParentData.crossOffSet =
          slotItem.slotIndex * tmpConstraints.minWidth / 4;
      slotHeight[slotItem.slotIndex] =
          slotItem.scrollOffset + slotItem.itemHeight;
      lastChild = child;
      if (minSlotHeight() > targetEndScrollOffset) {
        break;
      }
    }
    int trailingGarbage = calculateTrailingGarbage(
        lastIndex:
            (lastChild.parentData as _RenderSliverWaterFallParentData).index!);
    int leadingGarbage = calculateLeadingGarbage(firstIndex: firstIndex);
    collectGarbage(leadingGarbage, trailingGarbage);

    // This algorithm in principle is straight-forward: find the first child
    // that overlaps the given scrollOffset, creating more children at the top
    // of the list if necessary, then walk down the list updating and laying out
    // each child and adding more at the end if necessary until we have enough
    // children to cover the entire viewport.
    //
    // It is complicated by one minor issue, which is that any time you update
    // or create a child, it's possible that the some of the children that
    // haven't yet been laid out will be removed, leaving the list in an
    // inconsistent state, and requiring that missing nodes be recreated.
    //
    // To keep this mess tractable, this algorithm starts from what is currently
    // the first child, if any, and then walks up and/or down from there, so
    // that the nodes that might get removed are always at the edges of what has
    // already been laid out.

    // Make sure we have at least one child to start from.
    double estimatedMaxScrollOffset = slot[maxSlot(slot)].totalHeight;
    // if (reachedEnd) {
    //   estimatedMaxScrollOffset = endScrollOffset;
    // } else {
    //   estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
    //     constraints,
    //     firstIndex: indexOf(firstChild!),
    //     lastIndex: indexOf(lastChild!),
    //     leadingScrollOffset: childScrollOffset(firstChild!),
    //     trailingScrollOffset: endScrollOffset,
    //   );
    //   assert(estimatedMaxScrollOffset >= endScrollOffset - childScrollOffset(firstChild!)!);
    // }
    final double paintExtent = constraints.remainingPaintExtent;
    // final double targetEndScrollOffsetForPaint = constraints.scrollOffset + constraints.remainingPaintExtent;
    log("estimatedMaxScrollOffset:$estimatedMaxScrollOffset");
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: paintExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: true,
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    // if (estimatedMaxScrollOffset == endScrollOffset) {
    //   childManager.setDidUnderflow(true);
    // }
    childManager.didFinishLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    Offset p1 = Offset(offset.dx, offset.dy + 200);
    Offset p2 =
        Offset(offset.dx + constraints.crossAxisExtent, offset.dy + 200);
    context.canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2);

    Offset p3 =
        Offset(offset.dx, offset.dy + constraints.remainingPaintExtent - 200);
    Offset p4 = Offset(offset.dx + constraints.crossAxisExtent,
        offset.dy + constraints.remainingPaintExtent - 200);
    context.canvas.drawLine(
        p3,
        p4,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2);
  }
}
