import 'package:flutter/material.dart';
import 'dart:async';
import 'picker_theme.dart';
import 'picker_wrapper.dart';

class ColorPicker extends StatefulWidget {
  final Color? initialColor;
  final List<Color>? predefinedColors;
  final ValueChanged<Color>? onColorChanged;
  final PickerTheme theme;
  final bool enableOpacity;

  const ColorPicker({
    Key? key,
    this.initialColor,
    this.predefinedColors,
    this.onColorChanged,
    this.theme = const PickerTheme(),
    this.enableOpacity = false,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _selectedColor;
  late List<Color> _predefinedColors;
  late double _hue;
  late double _saturation;
  late double _value;
  late double _opacity;

  @override
  void initState() {
    super.initState();
    
    _selectedColor = widget.initialColor ?? Colors.red;
    _predefinedColors = widget.predefinedColors ?? _defaultColors;
    
    // HSV 값 초기화
    final HSVColor hsvColor = HSVColor.fromColor(_selectedColor);
    _hue = hsvColor.hue;
    _saturation = hsvColor.saturation;
    _value = hsvColor.value;
    _opacity = hsvColor.alpha;
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
      final HSVColor hsvColor = HSVColor.fromColor(color);
      _hue = hsvColor.hue;
      _saturation = hsvColor.saturation;
      _value = hsvColor.value;
      _opacity = hsvColor.alpha;
    });
    widget.onColorChanged?.call(color);
  }

  void _onHueChanged(double value) {
    setState(() {
      _hue = value;
      _updateSelectedColor();
    });
  }

  void _onSaturationChanged(double value) {
    setState(() {
      _saturation = value;
      _updateSelectedColor();
    });
  }

  void _onValueChanged(double value) {
    setState(() {
      _value = value;
      _updateSelectedColor();
    });
  }

  void _onOpacityChanged(double value) {
    setState(() {
      _opacity = value;
      _updateSelectedColor();
    });
  }

  void _updateSelectedColor() {
    _selectedColor = HSVColor.fromAHSV(_opacity, _hue, _saturation, _value).toColor();
    widget.onColorChanged?.call(_selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 선택된 색상 표시
        _buildSelectedColorDisplay(),
        
        const SizedBox(height: 16),
        
        // 미리 정의된 색상 팔레트
        _buildPredefinedColors(),
        
        const SizedBox(height: 16),
        
        // HSV 슬라이더
        _buildColorSliders(),
      ],
    );
  }

  Widget _buildSelectedColorDisplay() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: _selectedColor,
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
      ),
    );
  }

  Widget _buildPredefinedColors() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _predefinedColors.length,
      itemBuilder: (context, index) {
        final color = _predefinedColors[index];
        final isSelected = _selectedColor.value == color.value;
        
        return GestureDetector(
          onTap: () => _onColorSelected(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(widget.theme.borderRadius / 2),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorSliders() {
    return Column(
      children: [
        _buildSlider(
          label: 'H',
          value: _hue,
          max: 360,
          onChanged: _onHueChanged,
          gradient: _buildHueGradient(),
        ),
        _buildSlider(
          label: 'S',
          value: _saturation,
          max: 1.0,
          onChanged: _onSaturationChanged,
          gradient: _buildSaturationGradient(),
        ),
        _buildSlider(
          label: 'V',
          value: _value,
          max: 1.0,
          onChanged: _onValueChanged,
          gradient: _buildValueGradient(),
        ),
        if (widget.enableOpacity)
          _buildSlider(
            label: 'A',
            value: _opacity,
            max: 1.0,
            onChanged: _onOpacityChanged,
            gradient: _buildOpacityGradient(),
          ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
    required Gradient gradient,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              label,
              style: widget.theme.itemStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 12,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: widget.theme.primaryColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Slider(
                  value: value,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              label == 'H' ? value.toInt().toString() : value.toStringAsFixed(2),
              style: widget.theme.itemStyle,
            ),
          ),
        ],
      ),
    );
  }

  Gradient _buildHueGradient() {
    return const LinearGradient(
      colors: [
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
    );
  }

  Gradient _buildSaturationGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, _hue, 0.0, _value).toColor(),
        HSVColor.fromAHSV(1.0, _hue, 1.0, _value).toColor(),
      ],
    );
  }

  Gradient _buildValueGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, _hue, _saturation, 0.0).toColor(),
        HSVColor.fromAHSV(1.0, _hue, _saturation, 1.0).toColor(),
      ],
    );
  }

  Gradient _buildOpacityGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(0.0, _hue, _saturation, _value).toColor(),
        HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor(),
      ],
    );
  }

  static const List<Color> _defaultColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];
}

Future<Color?> showCustomColorPicker({
  required BuildContext context,
  Color? initialColor,
  List<Color>? predefinedColors,
  bool enableOpacity = false,
  String title = '색상 선택',
  PickerTheme? theme,
}) {
  final completer = Completer<Color?>();
  Color? selectedColor = initialColor;
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    child: ColorPicker(
      initialColor: initialColor,
      predefinedColors: predefinedColors,
      enableOpacity: enableOpacity,
      theme: theme ?? const PickerTheme(),
      onColorChanged: (color) {
        selectedColor = color;
      },
    ),
    onConfirm: () {
      Navigator.pop(context);
      completer.complete(selectedColor);
    },
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}
