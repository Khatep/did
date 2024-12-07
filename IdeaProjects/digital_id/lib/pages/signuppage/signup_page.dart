import 'package:digital_id/pages/inputdataformpage/input_data_form_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../domain/dtos/sign_up_request_dto.dart';
import '../../domain/dtos/sign_up_response_dto.dart';
import '../../domain/models/current_user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Logger _logger = Logger();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isCheckboxChecked = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  // Метод для проверки валидности ввода
  bool _isInputInvalid(String email, String password) {
    if (email.isEmpty) {
      _logger.w("Validation failed: Email is empty");
      _showError("Email cannot be empty");
      return true;
    }
    if (!email.contains("@") || !email.contains(".")) {
      _logger.w("Validation failed: Invalid email format - $email");
      _showError("Please enter a valid email address");
      return true;
    }
    if (password.isEmpty) {
      _logger.w("Validation failed: Password is empty");
      _showError("Password cannot be empty");
      return true;
    }
    if (password.length < 6) {
      _logger.w("Validation failed: Password is too short - ${password.length} characters");
      _showError("Password must be at least 6 characters long");
      return true;
    }
    if (!_isCheckboxChecked) {
      _logger.w("Validation failed: Terms and Conditions not accepted");
      _showError("You must agree with Terms and Conditions");
      return true;
    }
    _logger.i("Validation successful for email: $email");
    return false;
  }

  // Метод для отображения ошибок
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _signUp(String email, String password) async {
    const String endpoint = "http://mbp-yernurskiy.netbird.cloud:8080/api/v1/auth/register";

    final request = SignUpRequestDto(username: email, password: password);

    try {
      _setLoading(true); // Установить состояние загрузки
      _logger.i("Starting sign-up process...");
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _logger.i("Sign-up successful!");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final SignUpResponseDto signUpResponseResult = SignUpResponseDto.fromJson(responseBody);

        _logger.i("User registered: ${signUpResponseResult.username}, ID: ${signUpResponseResult.id}");
        await _loginAfterSignUp(email, password);
      } else {
        _logger.w("Sign-up failed: ${response.statusCode}");
        _showError("Failed to sign up. Error: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      _logger.e("An error occurred during sign-up", e, stackTrace);
      _showError("An error occurred: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loginAfterSignUp(String email, String password) async {
    const String loginEndpoint = "http://mbp-yernurskiy.netbird.cloud:8080/api/v1/auth/login";

    try {
      _logger.i("Starting login process...");
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i("Login successful!");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        CurrentUser currentUser = CurrentUser.fromJson(responseBody);

        // Перенаправляем пользователя
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputDataFormPage(currentUser: currentUser)),
        );
      } else {
        _logger.w("Login failed: ${response.statusCode}");
        _showError("Failed to log in. Error: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      _logger.e("An error occurred during login", e, stackTrace);
      _showError("An error occurred during login: $e");
    }
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
                "Create account",
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
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
              Row(
                children: [
                  Checkbox(
                    value: _isCheckboxChecked,
                    onChanged: (value) {
                      setState(() {
                        _isCheckboxChecked = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFF8F8FF),
                    checkColor: const Color(0xFF4169E1),
                  ),
                  const Expanded(
                    child: Text(
                      "I agree with Terms and Conditions",
                      style: TextStyle(fontSize: 16, color: Color(0xFFF8F8FF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8F8FF)),
                )
              else SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    if (!_isInputInvalid(email, password)) {
                      // Переход на следующую страницу, если данные корректны
                      _signUp(email, password);
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
                    "Sign Up",
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
