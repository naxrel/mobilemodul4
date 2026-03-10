import 'package:flutter/material.dart';

class HitungDigitScreen extends StatefulWidget {
  const HitungDigitScreen({super.key});

  @override
  State<HitungDigitScreen> createState() => _HitungDigitScreenState();
}

class _HitungDigitScreenState extends State<HitungDigitScreen> {
  final TextEditingController _controller = TextEditingController();
  int _totalDigits = 0;

  void _countDigits(String value) {
    // Menghapus semua karakter selain angka (0-9)
    // Jadi jika user input "100.5", hasilnya tetap 4 digit
    String cleanText = value.replaceAll(RegExp(r'[^0-9]'), '');

    setState(() {
      _totalDigits = cleanText.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                children: [
                  const Text('Total Karakter Angka:'),
                  Text(
                    '$_totalDigits',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Masukkan angka di bawah untuk melihat total digitnya',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Input Data Angka',
                hintText: 'Contoh: 12345',
                prefixIcon: const Icon(Icons.input),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _countDigits, // Otomatis update saat mengetik
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}