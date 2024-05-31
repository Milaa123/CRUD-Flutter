import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import './dashboard.dart'; // Import file dashboard.dart
import './register.dart'; // Import file register.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        'DashboardPage': (context) =>
            Home(), // Tambahkan rute untuk DashboardPage
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final response =
        await http.post(Uri.parse("http://localhost/unw/login.php"), body: {
      "username": usernameController.text,
      "password": passwordController.text,
    });

    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      Alert(
        context: context,
        title: "Login Gagal",
        desc: "Username atau password salah",
        type: AlertType.error,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Navigator.pushReplacementNamed(context, 'DashboardPage');
    }
  }

  Future<void> _register() async {
    final response =
        await http.post(Uri.parse("http://localhost/unw/register.php"), body: {
      "username": usernameController.text,
      "password": passwordController.text,
    });

    var data = json.decode(response.body);

    if (data['status'] == 'success') {
      Alert(
        context: context,
        title: "Registrasi Berhasil",
        desc: "Akun Anda telah berhasil terdaftar.",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        title: "Registrasi Gagal",
        desc: "Terjadi kesalahan saat mendaftar. Silakan coba lagi.",
        type: AlertType.error,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Tambahkan navigasi ke halaman registrasi
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text('Belum punya akun? Registrasi disini'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrasi'),
            ),
          ],
        ),
      ),
    );
  }
}
