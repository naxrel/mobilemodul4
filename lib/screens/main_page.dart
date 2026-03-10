import 'package:flutter/material.dart';
import 'package:tugas_modul4/screens/calculator_screen.dart';
import 'package:tugas_modul4/screens/pyramid_calculator_page.dart';
import 'package:tugas_modul4/screens/stopwatch_screen.dart';
import 'package:tugas_modul4/screens/number_checker_page.dart';

import 'hitung_digit_screen.dart';

class MainPage extends StatefulWidget {
  final String nama;
  const MainPage({super.key, required this.nama});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Calculator',
    'Cek angka',
    'Stopwatch',
    'Pyramid',
    'Hitung Digit',
  ];

  final List<Widget> _pages = const [
    CalculatorView(),
    NumberCheckerPage(),
    StopwatchScreen(),
    PyramidCalculatorPage(),
    HitungDigitScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 3. Panggil nama dengan widget.nama di sebelah title
        title: Text('${_titles[_selectedIndex]} - Halo, ${widget.nama}'),
        backgroundColor: const Color.fromARGB(255, 171, 193, 231),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[100], // Warna latar belakang
        selectedItemColor: Colors.blueAccent, // Warna ikon & teks saat dipilih
        unselectedItemColor: Colors.white,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.numbers_sharp),
            label: 'Cek angka',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_3_select),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_3_select),
            label: 'Pyramid',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pin), label: 'Hitung Digit'),
        ],
      ),
    );
  }
}
