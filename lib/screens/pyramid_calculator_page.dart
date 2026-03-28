import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/pyramid_painter.dart';



// void main() {
//   runApp(const PyramidApp());
// }

// class PyramidApp extends StatelessWidget {
//   const PyramidApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pyramid Calculator',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFFE8A020),
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//         fontFamily: 'Helvetica',
//       ),
//       home: const PyramidCalculatorPage(),
//     );
//   }
// }

class PyramidCalculatorPage extends StatefulWidget {
  const PyramidCalculatorPage({super.key});

  @override
  State<PyramidCalculatorPage> createState() => _PyramidCalculatorPageState();
}

class _PyramidCalculatorPageState extends State<PyramidCalculatorPage>
    with TickerProviderStateMixin {
  final TextEditingController _baseController = TextEditingController(text: '6');
  final TextEditingController _heightController = TextEditingController(text: '8');

  double _base = 6;
  double _height = 8;
  double _volume = 0;
  double _lateralArea = 0;
  double _totalArea = 0;
  double _slantHeight = 0;
  String? _minusError;

  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _rotateAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rotateAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _calculate();
  }

  void _calculate({bool showMessage = false}) {
    final parsedBase = double.tryParse(_baseController.text) ?? 0;
    final parsedHeight = double.tryParse(_heightController.text) ?? 0;

    if (parsedBase < 0 || parsedHeight < 0) {
      setState(() {
        _minusError = 'Nilai alas dan tinggi tidak boleh minus.';
        // Keep drawing dimensions non-negative to avoid painter geometry errors.
        _base = math.max(parsedBase, 0);
        _height = math.max(parsedHeight, 0);
        _volume = 0;
        _lateralArea = 0;
        _totalArea = 0;
        _slantHeight = 0;
      });

      if (showMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Input minus tidak diperbolehkan.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _minusError = null;
      _base = parsedBase;
      _height = parsedHeight;

      // Volume = (1/3) * a^2 * t
      _volume = (1 / 3) * _base * _base * _height;

      // Slant height = sqrt((a/2)^2 + t^2)
      _slantHeight = math.sqrt(math.pow(_base / 2, 2) + math.pow(_height, 2));

      // Lateral area = 4 * (1/2 * a * l) = 2 * a * l
      _lateralArea = 2 * _base * _slantHeight;

      // Total area = base + lateral = a^2 + 2*a*l
      _totalArea = _base * _base + _lateralArea;
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _baseController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 3D Pyramid Visualization
              Container(
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey.shade200),
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge([_rotateAnim, _pulseAnim]),
                  builder: (context, _) {
                    return CustomPaint(
                      painter: PyramidPainter(
                        rotateAngle: _rotateAnim.value,
                        scale: _pulseAnim.value,
                        base: math.max(_base, 0),
                        height: math.max(_height, 0),
                      ),
                      child: Container(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Input Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIMENSI',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      controller: _baseController,
                      label: 'Panjang Alas (a)',
                      icon: Icons.square_outlined,
                      unit: 'cm',
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      controller: _heightController,
                      label: 'Tinggi (t)',
                      icon: Icons.height,
                      unit: 'cm',
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _calculate(showMessage: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'HITUNG',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (_minusError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _minusError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Results
              if (_base > 0 && _height > 0) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HASIL',
                        style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResult(
                        label: 'Volume',
                        formula: 'V = ⅓ × a² × t',
                        value: _volume,
                        unit: 'cm³',
                        color: Colors.blueAccent,
                      ),
                      Divider(color: Colors.blueGrey.shade100, height: 24),
                      _buildResult(
                        label: 'Luas Selimut',
                        formula: 'L.sel = 2 × a × s',
                        value: _lateralArea,
                        unit: 'cm²',
                        color: Colors.teal,
                      ),
                      Divider(color: Colors.blueGrey.shade100, height: 24),
                      _buildResult(
                        label: 'Luas Permukaan Total',
                        formula: 'L = a² + 2 × a × s',
                        value: _totalArea,
                        unit: 'cm²',
                        color: Colors.redAccent,
                      ),
                      Divider(color: Colors.blueGrey.shade100, height: 24),
                      _buildResult(
                        label: 'Tinggi Selimut (s)',
                        formula: 's = √((a/2)² + t²)',
                        value: _slantHeight,
                        unit: 'cm',
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Formula Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KETERANGAN',
                        style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'a = panjang alas   t = tinggi   s = tinggi selimut\na = $_base cm   t = $_height cm   s = ${_slantHeight.toStringAsFixed(2)} cm',
                        style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 12,
                          height: 1.6,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String unit,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        suffixText: unit,
        suffixStyle: const TextStyle(color: Colors.blueAccent, fontSize: 13),
        filled: true,
        fillColor: Colors.blueGrey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
      onChanged: (_) => _calculate(),
    );
  }

  Widget _buildResult({
    required String label,
    required String formula,
    required double value,
    required String unit,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.blueGrey[500], fontSize: 12),
              ),
              Text(
                formula,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} $unit',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
