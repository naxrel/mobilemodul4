import 'package:flutter/material.dart';

class HitungDigitScreen extends StatefulWidget {
  const HitungDigitScreen({super.key});

  @override
  State<HitungDigitScreen> createState() => _HitungDigitScreenState();
}

class _HitungDigitScreenState extends State<HitungDigitScreen> {
  final TextEditingController _controller = TextEditingController();
  int _totalDigits = 0;
  int _sumOfDigits = 0; // Tambahan: State untuk menyimpan hasil jumlah

  void _countDigits(String value) {
    // Menghapus semua karakter selain angka (0-9)
    String cleanText = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Logika Penjumlahan Tiap Digit
    int currentSum = 0;
    for (int i = 0; i < cleanText.length; i++) {
      currentSum += int.parse(cleanText[i]);
    }

    setState(() {
      _totalDigits = cleanText.length;
      _sumOfDigits = currentSum; // Simpan hasil jumlah ke state
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
            // UI untuk Menampilkan Hasil
            Row(
              children: [
                // Box Total Digit
                Expanded(
                  child: _buildResultBox(
                    label: 'Total Digit',
                    value: '$_totalDigits',
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 12),
                // Box Jumlah Angka (Tambahan Baru)
                Expanded(
                  child: _buildResultBox(
                    label: 'Hasil Jumlah',
                    value: '$_sumOfDigits',
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Masukkan angka di bawah untuk melihat total digit dan penjumlahannya',
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
              onChanged: _countDigits,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper Widget agar UI tetap bersih (Clean Code)
  Widget _buildResultBox({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontSize: 40, // Ukuran sedikit diperkecil agar pas di Row
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}