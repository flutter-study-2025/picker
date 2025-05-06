import 'package:flutter/material.dart';

/// Builder function to create each item in the FlatPicker.
typedef FlatPickerItemBuilder =
    Widget Function(BuildContext context, int index, bool isSelected);

/// A customizable scroll-based picker with flat scrolling (not wheel-like).
class FlatPicker extends StatefulWidget {
  /// Total number of items in the picker.
  final int itemCount;

  /// Height of each item.
  final double itemExtent;

  /// Width of each item.
  final double itemWidth;

  /// Index of the initially selected item.
  final int initialIndex;

  /// Callback when selected item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// Builder function to construct each item widget.
  final FlatPickerItemBuilder itemBuilder;

  /// How many items are visible in the viewport at once.
  final int visibleItemCount;

  /// Color of the cover area (top and bottom) of the picker.
  final Color coverColor;

  /// Internal constructor used by both the default and named constructors.
  const FlatPicker._builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onSelectedItemChanged,
    this.itemExtent = 40.0,
    this.itemWidth = 100.0,
    this.initialIndex = 0,
    this.visibleItemCount = 5,
    this.coverColor = Colors.transparent,
  });

  /// Main constructor for users (same as builder).
  factory FlatPicker({
    required int itemCount,
    required FlatPickerItemBuilder itemBuilder,
    required ValueChanged<int> onSelectedItemChanged,
    double itemExtent = 40.0,
    double itemWidth = 100.0,
    int initialIndex = 0,
    int visibleItemCount = 5,
    Color coverColor = Colors.transparent,
  }) {
    return FlatPicker._builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onSelectedItemChanged: onSelectedItemChanged,
      itemExtent: itemExtent,
      itemWidth: itemWidth,
      initialIndex: initialIndex,
      visibleItemCount: visibleItemCount,
      coverColor: coverColor,
    );
  }

  /// Convenience constructor for simple string-based pickers.
  factory FlatPicker.string({
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
    int initialIndex = 0,
    double itemExtent = 40.0,
    double itemWidth = 100.0,
    int visibleItemCount = 5,
    TextStyle selectedTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    TextStyle defaultTextStyle = const TextStyle(color: Colors.grey),
    Color coverColor = Colors.transparent,
  }) {
    return FlatPicker._builder(
      itemCount: items.length,
      itemBuilder: (context, index, isSelected) {
        return Center(
          child: Text(
            items[index],
            style: isSelected ? selectedTextStyle : defaultTextStyle,
          ),
        );
      },
      onSelectedItemChanged: onSelectedItemChanged,
      itemExtent: itemExtent,
      itemWidth: itemWidth,
      initialIndex: initialIndex,
      visibleItemCount: visibleItemCount,
      coverColor: coverColor,
    );
  }

  @override
  State<FlatPicker> createState() => _FlatPickerState();
}

class _FlatPickerState extends State<FlatPicker> {
  late FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total height and width based on itemExtent and visibleItemCount
    final pickerHeight = widget.itemExtent * widget.visibleItemCount;
    final pickerWidth = widget.itemWidth * widget.visibleItemCount;

    return SizedBox(
      height: pickerHeight,
      width: pickerWidth,
      child: Stack(
        children: [
          // The actual picker (the scrollable ListWheelScrollView) is above the background
          Positioned.fill(
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: widget.itemExtent,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.00001, // No wheel-like effect
              useMagnifier: false, // Disable magnifier for smoothness
              onSelectedItemChanged: (index) {
                setState(() => _selectedIndex = index);
                widget.onSelectedItemChanged(index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= widget.itemCount) return null;
                  final isSelected = index == _selectedIndex;
                  return widget.itemBuilder(
                    context,
                    index,
                    isSelected,
                  ); // Building the item
                },
                childCount: widget.itemCount,
              ),
            ),
          ),
          // IgnorePointer for background (ensures background doesn't block user interaction)
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: pickerWidth, // Set width to match the picker
                height:
                    pickerHeight / 2 -
                    widget.itemExtent, // Set height to match the picker
                child: Container(
                  color: widget.coverColor, // Background color (shading effect)
                  // Background color (shading effect)
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: pickerWidth, // Set width to match the picker
                height:
                    pickerHeight / 2 -
                    widget.itemExtent, // Set height to match the picker
                child: Container(
                  color: widget.coverColor, // Background color (shading effect)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
