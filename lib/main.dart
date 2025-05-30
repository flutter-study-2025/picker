import 'package:flutter/material.dart';
import 'modules/picker_theme.dart';
import 'modules/date_picker.dart';
import 'modules/time_picker.dart';
import 'modules/date_time_picker.dart';
import 'modules/color_picker.dart';

void main() {
  runApp(const PickerApp());
}

class PickerApp extends StatelessWidget {
  const PickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pikcer toy project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: const PickerHomePage(title: '커스텀 Picker 모듈'),
    );
  }
}

class PickerHomePage extends StatefulWidget {
  const PickerHomePage({super.key, required this.title});
  final String title;

  @override
  State<PickerHomePage> createState() => _PickerHomePageState();
}

class _PickerHomePageState extends State<PickerHomePage> {
  DateTime? _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _selectedDateTime;
  Color _selectedColor = Colors.blue;

  PickerTheme lightTheme = PickerTheme.light();
  PickerTheme darkTheme = PickerTheme.dark();
  late PickerTheme currentTheme;

  @override
  void initState() {
    super.initState();
    currentTheme = lightTheme;
  }

  void _showDatePicker() async {
    final date = await showCustomDatePicker(
      context: context,
      initialDate: _selectedDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showTimePicker() async {
    final time = await showCustomTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _showDateTimePicker() async {
    final dateTime = await showCustomDateTimePicker(
      context: context,
      initialDateTime: _selectedDateTime,
    );

    if (dateTime != null) {
      setState(() {
        _selectedDateTime = dateTime;
      });
    }
  }

  void _showColorPicker() async {
    final color = await showCustomColorPicker(
      context: context,
      initialColor: _selectedColor,
    );

    if (color != null) {
      setState(() {
        _selectedColor = color;
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      currentTheme = currentTheme == lightTheme ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              currentTheme == lightTheme ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _showDatePicker,
              child: const Text('날짜 선택하기'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _showTimePicker,
              child: const Text('시간 선택하기'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _showDateTimePicker,
              child: const Text('날짜 및 시간 선택하기'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _showColorPicker,
              child: const Text('색상 선택하기'),
            ),
            const SizedBox(height: 24),

            // 선택한 값 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (_selectedDate != null)
                    Text(
                      '선택한 날짜: ${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),

                  if (_selectedTime != null)
                    Text(
                      '선택한 시간: ${_selectedTime.hour}시 ${_selectedTime.minute}분',
                      style: const TextStyle(fontSize: 16),
                    ),

                  if (_selectedDateTime != null)
                    Text(
                      '날짜/시간: ${_selectedDateTime!.year}년 ${_selectedDateTime!.month}월 ${_selectedDateTime!.day}일 ${_selectedDateTime!.hour}시 ${_selectedDateTime!.minute}분',
                      style: const TextStyle(fontSize: 16),
                    ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('선택한 색상: ', style: TextStyle(fontSize: 16)),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        // 해당 컬러에 대한 명시 죽이기 필요
                        '#${_selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
