import 'dart:convert';
import 'package:digital_id/pages/mainlogicpages/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';


import '../../domain/models/current_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger _logger = Logger(); // Инициализация логгера

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login(String email, String password) async {
    //final url = Uri.parse("http://100.78.113.13:8080/api/v1/auth/login");
    final url = Uri.parse("http://mbp-yernurskiy.netbird.cloud:8080/api/v1/auth/login");
    final body = jsonEncode({"username": email, "password": password});

    setState(() {
      _isLoading = true;
    });

    _logger.i("Attempting login with email: $email");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      _logger.d("Response received: ${response.statusCode}, ${response.body}");

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        CurrentUser currentUser = CurrentUser.fromJson(data);

        _logger.i("Login successful for user: ${currentUser.token}");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: currentUser)),
              (route) => false, // Удаляет все предыдущие маршруты
        );
      } else {
        _logger.w("Login failed with status code: ${response.statusCode}");
        _showError("Login failed. Please check your credentials.");
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      _logger.e("An error occurred during login: $error");
      _showError("An error occurred. Please try again.");
    }
  }

  bool _isInputInvalid(String email, String password) {
    if (email.isEmpty) {
      _logger.w("Validation failed: Email is empty");
      _showError("Email cannot be empty");
      return true;
    }
    if (!email.contains("@") || !email.contains(".")) {
      _logger.w("Validation failed: Invalid email format");
      _showError("Please enter a valid email address");
      return true;
    }
    if (password.isEmpty) {
      _logger.w("Validation failed: Password is empty");
      _showError("Password cannot be empty");
      return true;
    }
    if (password.length < 6) {
      _logger.w("Validation failed: Password too short");
      _showError("Password must be at least 6 characters long");
      return true;
    }
    _logger.d("Validation passed for email: $email");
    return false;
  }

  void _showError(String message) {
    _logger.e("Error shown to user: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4169E1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Login now",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFFF8F8FF),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
                cursorColor: const Color(0xFFF8F8FF),
                style: const TextStyle(color: Color(0xFFF8F8FF)),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Color(0xFFF8F8FF)),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFF8F8FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF8F8FF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                cursorColor: const Color(0xFFF8F8FF),
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Color(0xFFF8F8FF)),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Color(0xFFF8F8FF)),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFF8F8FF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFFF8F8FF),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF8F8FF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8F8FF)),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (!_isInputInvalid(email, password)) {
                        _login(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F8FF),
                      foregroundColor: const Color(0xFF4169E1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
