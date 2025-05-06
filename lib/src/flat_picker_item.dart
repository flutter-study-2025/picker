library;

import '../flat_picker.dart';

class PickerItem {
  final String label;
  final bool isSelected;
  final PickerStyle style;
  // Builds one item in the picker wheel

  const PickerItem({
    required this.label,
    required this.isSelected,
    required this.style,
  });
}
