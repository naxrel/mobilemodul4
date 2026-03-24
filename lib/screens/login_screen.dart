import 'package:flutter/material.dart';
import 'package:tugas_modul4/models/user.dart';
import 'package:tugas_modul4/screens/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String usernameInput = _usernameController.text;
    String passwordInput = _passwordController.text;
    final users = [user1, user2, user3, user4];

    // Mencari user yang cocok tanpa try-catch
    // Kita pakai cast ke User? (nullable) supaya bisa menangani kalau tidak ketemu
    final User? foundUser = users.cast<User?>().firstWhere(
      (u) => u!.username == usernameInput && u.password == passwordInput,
      orElse: () => null,
    );

    if (foundUser != null) {
      // Kalau ketemu, yang dikirim ke MainPage adalah foundUser.nama (bukan username)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(nama: foundUser.nama)),
      );
    } else {
      // Kalau null (nggak ketemu), munculin error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau Password Salah'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Input Username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            // Input Password (Obscure)
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 25),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
