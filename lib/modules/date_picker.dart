import 'package:flutter/material.dart';
import 'dart:async';
import 'picker_theme.dart';
import 'picker_wrapper.dart';

class DatePickerItem {
  final String text;
  final int value;

  DatePickerItem({required this.text, required this.value});
}

class DatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime>? onDateChanged;
  final PickerTheme theme;

  const DatePicker({
    Key? key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateChanged,
    this.theme = const PickerTheme(),
  }) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  
  late List<DatePickerItem> _years;
  late List<DatePickerItem> _months;
  late List<DatePickerItem> _days;

  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  @override
  void initState() {
    super.initState();
    
    final now = DateTime.now();
    final initialDate = widget.initialDate ?? now;
    
    _selectedYear = initialDate.year;
    _selectedMonth = initialDate.month;
    _selectedDay = initialDate.day;
    
    _initYears();
    _initMonths();
    _initDays();
    
    int yearIndex = _years.indexWhere((item) => item.value == _selectedYear);
    int monthIndex = _months.indexWhere((item) => item.value == _selectedMonth);
    int dayIndex = _days.indexWhere((item) => item.value == _selectedDay);
    
    _yearController = FixedExtentScrollController(initialItem: yearIndex);
    _monthController = FixedExtentScrollController(initialItem: monthIndex);
    _dayController = FixedExtentScrollController(initialItem: dayIndex);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initYears() {
    final minYear = widget.minDate?.year ?? DateTime.now().year - 100;
    final maxYear = widget.maxDate?.year ?? DateTime.now().year + 100;
    
    _years = List.generate(
      maxYear - minYear + 1,
      (index) => DatePickerItem(
        text: '${minYear + index}',
        value: minYear + index,
      ),
    );
  }

  void _initMonths() {
    _months = List.generate(
      12,
      (index) => DatePickerItem(
        text: _getMonthName(index + 1),
        value: index + 1,
      ),
    );
  }

  void _initDays() {
    final daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
    
    _days = List.generate(
      daysInMonth,
      (index) => DatePickerItem(
        text: '${index + 1}',
        value: index + 1,
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _onYearChanged(int index) {
    _selectedYear = _years[index].value;
    _updateDays();
    _notifyDateChanged();
  }

  void _onMonthChanged(int index) {
    _selectedMonth = _months[index].value;
    _updateDays();
    _notifyDateChanged();
  }

  void _onDayChanged(int index) {
    _selectedDay = _days[index].value;
    _notifyDateChanged();
  }

  void _updateDays() {
    setState(() {
      final daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
      _days = List.generate(
        daysInMonth,
        (index) => DatePickerItem(
          text: '${index + 1}',
          value: index + 1,
        ),
      );
      
      if (_selectedDay > _days.length) {
        _selectedDay = _days.length;
        _dayController.jumpToItem(_days.length - 1);
      }
    });
  }

  void _notifyDateChanged() {
    widget.onDateChanged?.call(DateTime(_selectedYear, _selectedMonth, _selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: _buildPicker(
              controller: _yearController,
              items: _years,
              onSelectedItemChanged: _onYearChanged,
            ),
          ),
          Expanded(
            child: _buildPicker(
              controller: _monthController,
              items: _months,
              onSelectedItemChanged: _onMonthChanged,
            ),
          ),
          Expanded(
            child: _buildPicker(
              controller: _dayController,
              items: _days,
              onSelectedItemChanged: _onDayChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<DatePickerItem> items,
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
}

// 커스텀 날짜 선택기 함수명 변경 (Flutter 기본 함수와 이름 충돌 방지)
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  String title = '날짜 선택',
  PickerTheme? theme,
}) {
  final completer = Completer<DateTime?>();
  DateTime? selectedDate = initialDate;
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    child: DatePicker(
      initialDate: initialDate,
      minDate: minDate,
      maxDate: maxDate,
      theme: theme ?? const PickerTheme(),
      onDateChanged: (date) {
        selectedDate = date;
      },
    ),
    onConfirm: () {
      Navigator.pop(context);
      completer.complete(selectedDate);
    },
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}

// Completer 클래스 추가
class Completer<T> {
  Function(T)? _complete;
  
  Future<T> get future => Future<T>((complete) {
    this._complete = complete;
  } as FutureOr<T> Function());
  
  void complete(T value) {
    if (_complete != null) {
      _complete!(value);
    }
  }
}
