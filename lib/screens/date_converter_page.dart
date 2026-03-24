import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateConverterPage extends StatefulWidget {
  @override
  _DateConverterPageState createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  bool isMasehiToHijri = true;
  DateTime selectedDate = DateTime.now();
  late HijriCalendar _selectedHijri;

  Future<void> _pilihTanggalMasehi(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedHijri = HijriCalendar.fromDate(selectedDate);
  }
  String get masehiToHijri {
    var h = HijriCalendar.fromDate(selectedDate);
    // Format: Tanggal NamaBulan Tahun H
    return "${h.hDay} ${h.longMonthName} ${h.hYear} H";
  }

  // FUNGSI 2: Konversi Hijriah ke Masehi
  String get hijriToMasehi {
    // Mengambil objek DateTime dari input Hijriah
    DateTime g = _selectedHijri.hijriToGregorian(
        _selectedHijri.hYear,
        _selectedHijri.hMonth,
        _selectedHijri.hDay
    );
    return DateFormat('dd MMMM yyyy', 'id_ID').format(g);
  }

  // FUNGSI 3: Handler saat User pilih tanggal Masehi
  Future<void> _pilihMasehi() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Sinkronkan objek hijri agar saat di-swap datanya sama
        _selectedHijri = HijriCalendar.fromDate(picked);
      });
    }
  }

  void toggleDirection() {
    setState(() {
      isMasehiToHijri = !isMasehiToHijri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Konverter Tanggal"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Card Input & Output
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    _buildDateSection(
                      label: isMasehiToHijri ? "Dari Masehi" : "Dari Hijriah",
                      value: isMasehiToHijri
                          ? DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate)
                          : "5 Syawal 1447 H", // Simulasi input Hijriah
                      isInput: true,
                    ),

                    const SizedBox(height: 10),

                    // Tombol Swap Tengah
                    IconButton(
                      icon: Icon(Icons.swap_vert_circle, size: 45, color: Colors.teal),
                      onPressed: toggleDirection,
                    ),

                    const SizedBox(height: 10),

                    _buildDateSection(
                      label: isMasehiToHijri ? "Ke Hijriah" : "Ke Masehi",
                      value: isMasehiToHijri ? masehiToHijri : hijriToMasehi,
                      isInput: false,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Pilih Tanggal
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (isMasehiToHijri) {
                    _pilihTanggalMasehi(context);
                  } else {
                    _pilihTanggalHijriahCustom(context);
                  }
                },
                icon: Icon(Icons.calendar_month),
                label: Text("Pilih Tanggal", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection({required String label, required String value, required bool isInput}) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isInput ? Colors.black87 : Colors.teal[700]
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _pilihTanggalHijriahCustom(BuildContext context) async {
    final HijriCalendar now = HijriCalendar.now();

    // Kita buat dialog sederhana berisi list bulan & tahun
    // Atau cara paling simpel: gunakan showDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pilih Tanggal Hijriah"),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Di sini kamu bisa buat UI slider atau list sederhana
                // Sebagai contoh cepat, kita simulasikan pemilihan:
                ListTile(
                  title: Text("Gunakan Tanggal Hari Ini"),
                  subtitle: Text(now.fullDate()),
                  onTap: () {
                    setState(() {
                      // logic konversi balik ke masehi
                      selectedDate = now.hijriToGregorian(now.hYear, now.hMonth, now.hDay);
                    });
                    Navigator.pop(context);
                  },
                ),
                Text("Tips: Untuk UI yang lebih kompleks, kamu bisa gunakan widget 'CupertinoDatePicker' atau 'WheelPicker' agar tidak error Material 3."),
              ],
            ),
          ),
        );
      },
    );
  }

}

