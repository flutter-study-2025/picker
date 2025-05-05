import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picker/custom_date_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '플러터 커스텀 DatePicker',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _TodayDate(dateTime: dateTime),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showDatePicker,
              child: const Text('날짜 선택'),
            ),
          ],
        ),
      ),
    );
  }

  void showDatePicker() {
    CustomDatePicker.show(
      context: context,
      title: '날짜 선택',
      initialDateTime: dateTime ?? DateTime.now(),
      onDateTimePicked: (value) {
        setState(() {
          dateTime = value;
        });
      },
    );
  }
}

class _TodayDate extends StatelessWidget {
  final DateTime? dateTime;

  const _TodayDate({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('오늘의 날짜는'),
          const SizedBox(height: 4),
          Text(
            dateTime == null ? '"선택 안됨"' : DateFormat.yMMMMd().format(dateTime!),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
