import 'package:flutter/material.dart';

/// 스타일 조절 가능한 부분
/// 1. 배경색
/// 2. 초점 글자 위치 (중앙, 상단, 하단)

class PickerStyle {
  final TextStyle selectedTextStyle;
  final TextStyle defaultTextStyle;
  final double itemHeight;
  final Color backgroundColor;
  final BoxDecoration? highlightDecoration;

  /// Creates a [PickerStyle] with the given parameters.
  const PickerStyle({
    this.selectedTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    this.defaultTextStyle = const TextStyle(fontSize: 16, color: Colors.grey),
    this.itemHeight = 50.0,
    this.backgroundColor = Colors.white,
    this.highlightDecoration,
  });
}
