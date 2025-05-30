import 'package:flutter/material.dart';
import 'dart:async';
import 'picker_theme.dart';
import 'picker_wrapper.dart';
import 'date_picker.dart';
import 'time_picker.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final bool use24HourFormat;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final PickerTheme theme;

  const DateTimePicker({
    Key? key,
    this.initialDateTime,
    this.minDateTime,
    this.maxDateTime,
    this.use24HourFormat = false,
    this.onDateTimeChanged,
    this.theme = const PickerTheme(),
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDateTime;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    });
    widget.onDateTimeChanged?.call(_selectedDateTime);
  }
  
  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        time.hour,
        time.minute,
      );
    });
    widget.onDateTimeChanged?.call(_selectedDateTime);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: widget.theme.primaryColor,
          labelColor: widget.theme.primaryColor,
          unselectedLabelColor: widget.theme.textColor,
          tabs: const [
            Tab(text: '날짜'),
            Tab(text: '시간'),
          ],
        ),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: [
              DatePicker(
                initialDate: _selectedDateTime,
                minDate: widget.minDateTime,
                maxDate: widget.maxDateTime,
                theme: widget.theme,
                onDateChanged: _onDateChanged,
              ),
              TimePicker(
                initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                use24HourFormat: widget.use24HourFormat,
                theme: widget.theme,
                onTimeChanged: _onTimeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<DateTime?> showCustomDateTimePicker({
  required BuildContext context,
  DateTime? initialDateTime,
  DateTime? minDateTime,
  DateTime? maxDateTime,
  bool use24HourFormat = false,
  String title = '날짜 및 시간 선택',
  PickerTheme? theme,
}) {
  final completer = Completer<DateTime?>();
  DateTime? selectedDateTime = initialDateTime;
  
  showPickerModal(
    context: context,
    title: title,
    theme: theme,
    child: DateTimePicker(
      initialDateTime: initialDateTime,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      use24HourFormat: use24HourFormat,
      theme: theme ?? const PickerTheme(),
      onDateTimeChanged: (dateTime) {
        selectedDateTime = dateTime;
      },
    ),
    onConfirm: () {
      Navigator.pop(context);
      completer.complete(selectedDateTime);
    },
    onCancel: () {
      Navigator.pop(context);
      completer.complete(null);
    },
  );
  
  return completer.future;
}
