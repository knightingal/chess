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
  List<int> bottom = <int>[
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37,
  ];

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    for (int i = 0; i < bottom.length; i++) {
      int slotIndex = minSlot(slot);
      Slot slotOne = slot[slotIndex];
      slotOne.slotItemList.add(SlotItem(i, slotOne.totalHeight, 100 + i % 4 * 20.0, slotIndex));
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
              bottom.add(bottom.length);
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
                  height: 100 + bottom[index] % 4 * 20.0,
                  // height: 100 ,
                  width: 0,
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
  double min = 1000000;
  int index = 5;
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
    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    log("scrollOffset:$scrollOffset, constraints.scrollOffset:${constraints.scrollOffset}, constraints.cacheOrigin:${constraints.cacheOrigin}");
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    final BoxConstraints tmpConstraints = constraints.asBoxConstraints();
    final BoxConstraints childConstraints = BoxConstraints(
      maxHeight: tmpConstraints.maxHeight,
      minHeight: tmpConstraints.minHeight,
      maxWidth: tmpConstraints.maxWidth,
      minWidth: tmpConstraints.minWidth / 4,
    );
    int leadingGarbage = 0;
    int trailingGarbage = 0;

    if (firstChild == null) {
      addInitialChild();
    }

    firstChild!.layout(childConstraints, parentUsesSize: true);

    RenderBox? child;
    _RenderSliverWaterFallParentData childParentData;

    child = childAfter(firstChild!);
    if (child == null) {
      child = insertAndLayoutChild(childConstraints, after: firstChild, parentUsesSize: true);
    } else {
      child.layout(childConstraints, parentUsesSize: true);
    }
    childParentData = child!.parentData! as _RenderSliverWaterFallParentData;
    SlotItem? slotItem = findSlotByIndex(slot, childParentData.index!);
    childParentData.layoutOffset = slotItem!.scrollOffset;
    childParentData.crossOffSet = slotItem.slotIndex * tmpConstraints.minWidth / 4;
    

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
    const double estimatedMaxScrollOffset = 1240;
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
    final double targetEndScrollOffsetForPaint = constraints.scrollOffset + constraints.remainingPaintExtent;
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
  
}