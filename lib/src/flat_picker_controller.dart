import 'package:flutter/widgets.dart';

class FlatPickerController {
  final FixedExtentScrollController controller;

  FlatPickerController({int initialIndex = 0})
    : controller = FixedExtentScrollController(initialItem: initialIndex);

  void animateTo(
    int index, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    controller.animateToItem(
      index,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  int get selectedItem => controller.selectedItem;
}
