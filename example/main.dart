import 'package:flutter/material.dart';
import 'package:picker/flat_picker.dart';

/// 비용, 인프라 -> 지표 위주로
/// 깃허브와 링크

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatPicker(
              itemCount: 10,
              itemBuilder: (context, index, isSelected) => Container(
                height: 50,
                width: 100,
                color: Colors.blue.withOpacity(0.2),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              onSelectedItemChanged: (index) => print('Selected: $index'),
              itemExtent: 50,
              itemWidth: 100,
              initialIndex: 0,
              visibleItemCount: 5,
              coverColor: Colors.black,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
