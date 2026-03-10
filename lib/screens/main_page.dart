import 'package:flutter/material.dart';
import 'package:tugas_modul4/screens/calculator_screen.dart';
import 'package:tugas_modul4/screens/pyramid_calculator_page.dart';
import 'package:tugas_modul4/screens/stopwatch_screen.dart';
import 'package:tugas_modul4/screens/number_checker_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Calculator', 'Cek angka', 'Stopwatch','pyramid'];

  final List<Widget> _pages = const [
    CalculatorView(),
    NumberCheckerPage(),
    StopwatchScreen(),
    PyramidCalculatorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.numbers_sharp), label: 'Cek angka'),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_3_select),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_3_select),
            label: 'Stopwatch',
          ),
        ],
      ),
    );
  }
}
