import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateWetonPage extends StatefulWidget {
  const DateWetonPage({super.key});

  @override
  State<DateWetonPage> createState() => _DateWetonPageState();
}

class _DateWetonPageState extends State<DateWetonPage> {
  static const List<String> _hariMasehi = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _pasaran = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  static const List<String> _wuku = [
    'Sinta',
    'Landep',
    'Wukir',
    'Kurantil',
    'Tolu',
    'Gumbreg',
    'Warigalit',
    'Warigagung',
    'Julungwangi',
    'Sungsang',
    'Galungan',
    'Kuningan',
    'Langkir',
    'Mandasiya',
    'Julungpujud',
    'Pahang',
    'Kuruwelut',
    'Marakeh',
    'Tambir',
    'Medangkungan',
    'Maktal',
    'Wuye',
    'Manahil',
    'Prangbakat',
    'Bala',
    'Wugu',
    'Wayang',
    'Kulawu',
    'Dukut',
    'Watugunung',
  ];

  static const List<String> _warsa = [
    'Alip',
    'Ehe',
    'Jimawal',
    'Je',
    'Dal',
    'Be',
    'Wawu',
    'Jimakir',
  ];

  // 17 Agustus 1945 dikenal sebagai Jumat Legi.
  static final DateTime _wetonReference = DateTime(1945, 8, 17);
  static const int _pasaranReferenceIndex = 0; // Legi

  // Referensi siklus pawukon 210 hari. Nilai ini dipakai sebagai anchor perhitungan.
  static final DateTime _wukuReference = DateTime(1945, 8, 17);
  static const int _wukuReferenceIndex = 9; // Sungsang

  DateTime _selectedDate = DateTime.now();

  String _formatTanggal(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  int _positiveMod(int value, int mod) {
    final int r = value % mod;
    return r < 0 ? r + mod : r;
  }

  String _hitungWeton(DateTime date) {
    final int hariIndex = date.weekday - 1;
    final int diffDays = date.difference(_wetonReference).inDays;
    final int pasaranIndex =
        _positiveMod(_pasaranReferenceIndex + diffDays, _pasaran.length);
    return '${_hariMasehi[hariIndex]} ${_pasaran[pasaranIndex]}';
  }

  String _hitungWuku(DateTime date) {
    final int diffDays = date.difference(_wukuReference).inDays;
    final int wukuIndex = _positiveMod(_wukuReferenceIndex + (diffDays ~/ 7), _wuku.length);
    return _wuku[wukuIndex];
  }

  String _hitungWarsa(DateTime date) {
    final HijriCalendar hijri = HijriCalendar.fromDate(date);
    final int tahunJawa = hijri.hYear + 512;
    final int indexWarsa = _positiveMod(tahunJawa - 1555, _warsa.length);
    return '$tahunJawa AJ (${_warsa[indexWarsa]})';
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = picked;
    });
  }

  Widget _buildResultTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.teal.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String weton = _hitungWeton(_selectedDate);
    final String wuku = _hitungWuku(_selectedDate);
    final String warsa = _hitungWarsa(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Konverter Masehi ke Weton'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal Masehi',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTanggal(_selectedDate),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _pilihTanggal,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Pilih Tanggal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildResultTile(
              title: 'Weton',
              value: weton,
              icon: Icons.event_note,
            ),
            const SizedBox(height: 12),
            _buildResultTile(
              title: 'Wuku',
              value: wuku,
              icon: Icons.view_week,
            ),
            const SizedBox(height: 12),
            _buildResultTile(
              title: 'Warsa',
              value: warsa,
              icon: Icons.history_edu,
            ),
            const SizedBox(height: 16),
            Text(
              'Catatan: perhitungan berbasis siklus kalender Jawa (pasaran 5 hari, pawukon 30 wuku, dan warsa windu).',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}