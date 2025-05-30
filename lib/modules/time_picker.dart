import 'package:flutter/material.dart';
import 'dart:async';
import 'picker_theme.dart';
import 'picker_wrapper.dart';

class TimePickerItem {
  final String text;
  final int value;

  TimePickerItem({required this.text, required this.value});
}

class TimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final bool use24HourFormat;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final PickerTheme theme;

  const TimePicker({
    Key? key,
    required this.initialTime,
    this.use24HourFormat = false,
    this.onTimeChanged,
    this.theme = const PickerTheme(),
  }) : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod;
  
  late List<TimePickerItem> _hours;
  late List<TimePickerItem> _minutes;
  late List<String> _periods;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    
    final initialTime = widget.initialTime;
    
    _initHours();
    _initMinutes();
    _initPeriods();
    
    if (widget.use24HourFormat) {
      _selectedHour = initialTime.hour;
      int hourIndex = _hours.indexWhere((item) => item.value == _selectedHour);
      _hourController = FixedExtentScrollController(initialItem: hourIndex);
    } else {
      _selectedHour = initialTime.hourOfPeriod;
      _selectedPeriod = initialTime.period == DayPeriod.am ? 'AM' : 'PM';
      int hourIndex = _hours.indexWhere((item) => item.value == _selectedHour);
      int periodIndex = _periods.indexOf(_selectedPeriod);
      _hourController = FixedExtentScrollController(initialItem: hourIndex);
      _periodController = FixedExtentScrollController(initialItem: periodIndex);
    }
    
    _selectedMinute = initialTime.minute;
    int minuteIndex = _minutes.indexWhere((item) => item.value == _selectedMinute);
    _minuteController = FixedExtentScrollController(initialItem: minuteIndex);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _initHours() {
    if (widget.use24HourFormat) {
      _hours = List.generate(
        24,
        (index) => TimePickerItem(
          text: index < 10 ? '0$index' : '$index',
          value: index,
        ),
      );
    } else {
      _hours = List.generate(
        12,
        (index) => TimePickerItem(
          text: '${index + 1}',
          value: index + 1,
        ),
      );
    }
  }

  void _initMinutes() {
    _minutes = List.generate(
      60,
      (index) => TimePickerItem(
        text: index < 10 ? '0$index' : '$index',
        value: index,
      ),
    );
  }

  void _initPeriods() {
    _periods = ['AM', 'PM'];
  }

  void _onHourChanged(int index) {
    _selectedHour = _hours[index].value;
    _notifyTimeChanged();
  }

  void _onMinuteChanged(int index) {
    _selectedMinute = _minutes[index].value;
    _notifyTimeChanged();
  }

  void _onPeriodChanged(int index) {
    _selectedPeriod = _periods[index];
    _notifyTimeChanged();
  }

  void _notifyTimeChanged() {
    int hour = _selectedHour;
    
    if (!widget.use24HourFormat) {
      if (_selectedPeriod == 'PM' && _selectedHour != 12) {
        hour = _selectedHour + 12;
      } else if (_selectedPeriod == 'AM' && _selectedHour == 12) {
        hour = 0;
      }
    }
    
    widget.onTimeChanged?.call(TimeOfDay(hour: hour, minute: _selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: _buildPicker(
              controller: _hourController,
              items: _hours,
              onSelectedItemChanged: _onHourChanged,
            ),
          ),
          Expanded(
            child: _buildPicker(
              controller: _minuteController,
              items: _minutes,
              onSelectedItemChanged: _onMinuteChanged,
            ),
          ),
          if (!widget.use24HourFormat)
            Expanded(
              child: _buildPeriodPicker(),
            ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<TimePickerItem> items,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: widget.theme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final isSelected = controller.selectedItem == index;
            return Center(
              child: Text(
                items[index].text,
                style: isSelected
                    ? widget.theme.selectedItemStyle.copyWith(color: widget.theme.selectedItemColor)
                    : widget.theme.itemStyle.copyWith(color: widget.theme.textColor),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodPicker() {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: widget.theme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: _periodController,
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: _onPeriodChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: _periods.length,
          builder: (context, index) {
            final isSelected = _periodController.selectedItem == index;
            return Center(
              child: Text(
                _periods[index],
                style: isSelected
                    ? widget.theme.selectedItemStyle.copyWith(color: widget.theme.selectedItemColor)
                    : widget.theme.itemStyle.copyWith(color: widget.theme.textColor),
              ),
            );
          },
        ),
      ),
    );
  }
}

// 커스텀 시간 선택기 함수명 변경 (Flutter 기본 함수와 이름 충돌 방지)
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  bool use24HourFormat = false,
  String title = '시간 선택',
  PickerTheme? theme,
}) {
  final completer = Completer<TimeOfDay?>();
  TimeOfDay selectedTime = initialTime;
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    child: TimePicker(
      initialTime: initialTime,
      use24HourFormat: use24HourFormat,
      theme: theme ?? const PickerTheme(),
      onTimeChanged: (time) {
        selectedTime = time;
      },
    ),
    onConfirm: () {
      Navigator.pop(context);
      completer.complete(selectedTime);
    },
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}

// Completer 클래스 정의가 이미 date_picker.dart에 있으므로 여기서는 생략합니다.
