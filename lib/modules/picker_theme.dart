import 'package:flutter/material.dart';

enum PickerThemeStyle {
  light,
  dark,
  custom,
}

class PickerTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color selectedTextColor;
  final Color selectedItemColor;
  final double borderRadius;
  final TextStyle titleStyle;
  final TextStyle itemStyle;
  final TextStyle selectedItemStyle;

  const PickerTheme({
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.selectedTextColor = Colors.white,
    this.selectedItemColor = Colors.blue,
    this.borderRadius = 12.0,
    this.titleStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.itemStyle = const TextStyle(fontSize: 16),
    this.selectedItemStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  });

  factory PickerTheme.light() {
    return const PickerTheme();
  }

  factory PickerTheme.dark() {
    return const PickerTheme(
      primaryColor: Colors.indigo,
      backgroundColor: Color(0xFF303030),
      textColor: Colors.white70,
      selectedTextColor: Colors.white,
      selectedItemColor: Colors.indigoAccent,
    );
  }

  PickerTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? selectedTextColor,
    Color? selectedItemColor,
    double? borderRadius,
    TextStyle? titleStyle,
    TextStyle? itemStyle,
    TextStyle? selectedItemStyle,
  }) {
    return PickerTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      borderRadius: borderRadius ?? this.borderRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      selectedItemStyle: selectedItemStyle ?? this.selectedItemStyle,
    );
  }
}
