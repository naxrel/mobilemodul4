import 'package:flutter/material.dart';

class BirthdayScreen extends StatelessWidget {
  const BirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BirthdayView());
  }
}

class BirthdayView extends StatefulWidget {
  const BirthdayView({super.key});

  @override
  State<BirthdayView> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayView> {
  DateTime? selectedDate;
  TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);

  String result = "";

  void hitung() {
    if (selectedDate == null) return;

    DateTime birth = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    DateTime now = DateTime.now();

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;
    int hours = now.hour - birth.hour;
    int minutes = now.minute - birth.minute;

    if (minutes < 0) {
      minutes += 60;
      hours--;
    }

    if (hours < 0) {
      hours += 24;
      days--;
    }

    if (days < 0) {
      DateTime lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    // ===== WETON =====
    List<String> pasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];
    List<String> hari = [
      "Minggu",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
    ];

    DateTime baseDate = DateTime(1938, 1, 1);
    int selisihHari = birth.difference(baseDate).inDays;

    int pasaranIndex = ((selisihHari % 5) + 5) % 5;
    int hariIndex = birth.weekday % 7;

    String weton = "${hari[hariIndex]} ${pasaran[pasaranIndex]}";

    // ===== SHIO =====
    List<String> shioList = [
      "Tikus",
      "Kerbau",
      "Macan",
      "Kelinci",
      "Naga",
      "Ular",
      "Kuda",
      "Kambing",
      "Monyet",
      "Ayam",
      "Anjing",
      "Babi",
    ];

    int shioIndex = (birth.year - 4) % 12;
    String shio = shioList[(shioIndex + 12) % 12];

    // ===== KABISAT =====
    int year = birth.year;
    bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

    setState(() {
      result =
          """
Umur:
$years tahun, $months bulan, $days hari
$hours jam, $minutes menit

Weton: $weton
Shio: $shio
Tahun Kabisat: ${isLeap ? "Ya" : "Tidak"}
""";
    });
  }

  Future<void> pickDate() async {
    DateTime now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  Widget buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String formatResult(String raw) {
    return raw
        .replaceAll("Umur:", "Umur:")
        .replaceAll("Weton:", "Weton:")
        .replaceAll("Shio:", "Shio:")
        .replaceAll("Tahun Kabisat:", "Tahun Kabisat:");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFFe0f7ff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Birthday Date Checker :3",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DATE BUTTON
                    buildGradientButton(
                      selectedDate == null
                          ? "Pilih Tanggal"
                          : " ${selectedDate.toString().split(" ")[0]}",
                      pickDate,
                    ),

                    const SizedBox(height: 10),

                    // TIME BUTTON
                    buildGradientButton(
                      " ${selectedTime.format(context)}",
                      pickTime,
                    ),

                    const SizedBox(height: 15),

                    // HITUNG BUTTON
                    GestureDetector(
                      onTap: hitung,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "Hitung Sekarang",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // RESULT BOX
                    if (result.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFd4fc79), Color(0xFF96e6a1)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          formatResult(result),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
