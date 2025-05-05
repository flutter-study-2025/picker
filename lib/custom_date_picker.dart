import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  // 최초 날짜
  final DateTime initialDateTime;

  // 확인 콜백
  final ValueChanged<DateTime> onDateTimePicked;

  // 제목
  final String title;

  const CustomDatePicker({
    required this.title,
    required this.initialDateTime,
    required this.onDateTimePicked,
    super.key,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required DateTime initialDateTime,
    required ValueChanged<DateTime> onDateTimePicked,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return CustomDatePicker(
          title: title,
          initialDateTime: initialDateTime,
          onDateTimePicked: onDateTimePicked,
        );
      },
    );
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: SafeArea(
        child: Column(
          children: [
            _Header(
              title: widget.title,
              onConfirm: () {
                widget.onDateTimePicked(dateTime);
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: dateTime,
                onDateTimeChanged: (value) => dateTime = value,
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _Header({
    required this.title,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              textStyle: textStyle,
            ),
            child: const Text('취소'),
          ),
          Text(
            title,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              textStyle: textStyle,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
