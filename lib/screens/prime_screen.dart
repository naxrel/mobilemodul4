import 'package:flutter/material.dart';

void main() {
  runApp(const PrimeScreen());
}

class PrimeScreen extends StatelessWidget {
  const PrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cek angka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NumberCheckerPage(),
    );
  }
}

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({super.key});

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  // Controller to read the text typed into the TextField
  final TextEditingController _numberController = TextEditingController();
  
  // Variable to hold the result message displayed on the screen
  String _resultMessage = "";

  // Function to process the number using modulo and if/else statements
  void _checkNumber() {
    String inputText = _numberController.text;

    // Basic validation to ensure the input is not empty
    if (inputText.isEmpty) {
      setState(() {
        _resultMessage = "Silakan masukkan bilangan yang valid.";
      });
      return;
    }

    // Try to parse the text to an integer
    int? number = int.tryParse(inputText);

    if (number == null) {
      setState(() {
        _resultMessage = "Angka aja ya";
      });
      return;
    }

    // 1. Check Odd or Even using modulo (%)
    String oddEvenResult;
    if (number % 2 == 0) {
      oddEvenResult = "Genap";
    } else {
      oddEvenResult = "Ganjil";
    }
    // 2. Check Prime using modulo (%)
    bool isPrime = true;
    // Numbers less than or equal to 1 are not prime numbers
    if (number <= 1) {
      isPrime = false;
    } else {
      // Loop from 2 up to half the number to check for factors
      for (int i = 2; i <= number ~/ 2; i++) {
        // If the number is cleanly divisible by 'i', it's not prime
        if (number % i == 0) {
          isPrime = false;
          break; // Stop checking further, we already know it's not prime
        }
      }
    }

    String primeResult;
    if (isPrime) {
      primeResult = "sebuah bilangan prima";
    } else {
      primeResult = "bukan bilangan prima";
    }

    // Update the UI with the final string
    setState(() {
      _resultMessage = "Angka $number merupakan $oddEvenResult dan $primeResult.";
    });
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // The Input Field
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number, // Shows the number keyboard
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukkan angka',
              ),
            ),
            const SizedBox(height: 20.0),
            
            // The Check Button
            ElevatedButton(
              onPressed: _checkNumber,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Cek',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40.0),
            
            // The Result Display
            Text(
              _resultMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}