import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class DateConverterPage extends StatefulWidget {
  @override
  _DateConverterPageState createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  static const List<String> _hijriMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

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
        _selectedHijri = HijriCalendar.fromDate(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedHijri = HijriCalendar.fromDate(selectedDate);
  }

  int _getHijriMonthDays(int year, int month) {
    final DateTime monthStart = _selectedHijri.hijriToGregorian(year, month, 1);
    final int nextMonth = month == 12 ? 1 : month + 1;
    final int nextYear = month == 12 ? year + 1 : year;
    final DateTime nextMonthStart =
        _selectedHijri.hijriToGregorian(nextYear, nextMonth, 1);
    return nextMonthStart.difference(monthStart).inDays;
  }

  String get _selectedHijriText {
    return '${_selectedHijri.hDay} ${_hijriMonths[_selectedHijri.hMonth - 1]} ${_selectedHijri.hYear} H';
  }

  String get masehiToHijri {
    var h = HijriCalendar.fromDate(selectedDate);
    // Format: Tanggal NamaBulan Tahun H
    return '${h.hDay} ${_hijriMonths[h.hMonth - 1]} ${h.hYear} H';
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
                          : _selectedHijriText,
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
    int tempDay = _selectedHijri.hDay;
    int tempMonth = _selectedHijri.hMonth;
    int tempYear = _selectedHijri.hYear;
    int tempMaxDays = _getHijriMonthDays(tempYear, tempMonth);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
          title: const Text('Pilih Tanggal Hijriah'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: tempDay,
                  decoration: const InputDecoration(labelText: 'Hari'),
                  items: List.generate(tempMaxDays, (index) => index + 1)
                      .map(
                        (day) => DropdownMenuItem<int>(
                          value: day,
                          child: Text('$day'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setDialogState(() {
                      tempDay = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: tempMonth,
                  decoration: const InputDecoration(labelText: 'Bulan'),
                  items: List.generate(12, (index) => index + 1)
                      .map(
                        (month) => DropdownMenuItem<int>(
                          value: month,
                          child: Text(_hijriMonths[month - 1]),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setDialogState(() {
                      tempMonth = value;
                      tempMaxDays = _getHijriMonthDays(tempYear, tempMonth);
                      if (tempDay > tempMaxDays) {
                        tempDay = tempMaxDays;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: tempYear,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  items: List.generate(301, (index) => 1300 + index)
                      .map(
                        (year) => DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year H'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setDialogState(() {
                      tempYear = value;
                      tempMaxDays = _getHijriMonthDays(tempYear, tempMonth);
                      if (tempDay > tempMaxDays) {
                        tempDay = tempMaxDays;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final DateTime masehi =
                    _selectedHijri.hijriToGregorian(tempYear, tempMonth, tempDay);
                setState(() {
                  selectedDate = masehi;
                  _selectedHijri = HijriCalendar.fromDate(masehi);
                });
                Navigator.pop(context);
              },
              child: const Text('Pilih'),
            ),
          ],
        ),
        );
      },
    );
  }

}

