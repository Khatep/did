import 'dart:convert'; // Для декодирования токена
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http; // Добавление библиотеки для HTTP запросов

import '../../../domain/models/current_user.dart';

class GenerateQRPage extends StatefulWidget {
  final CurrentUser currentUser;

  const GenerateQRPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  String? _selectedOption = "Read data access"; // Выбранный вариант
  String? _qrData; // Данные для генерации QR-кода

  // Метод для отправки запроса на сервер и получения нового токена
  Future<void> _sendGenerateQRRequest() async {
    final token = widget.currentUser.token;

    // Устанавливаем isAccept в зависимости от выбранного варианта
    final isAccept = _selectedOption != "Read data access";

    final response = await http.post(
      Uri.parse('http://mbp-yernurskiy.netbird.cloud:8080/api/v1/qr/generate-qr'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Добавление токена в заголовок
      },
      body: jsonEncode({
        'isAccept': isAccept,
      }),
    );

    if (response.statusCode == 200) {
      // Парсим ответ и получаем новый токен
      final responseData = jsonDecode(response.body);
      final newToken = responseData['token'];

      // Генерация данных для QR на основе нового токена
      _generateQRWithNewToken(newToken);
    } else {
      // Обработка ошибки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.statusCode}")),
      );
    }
  }

  // Метод для генерации QR с новым токеном
  void _generateQRWithNewToken(String newToken) {
    // Пример данных для QR, которые можно генерировать с новым токеном
    _qrData = jsonEncode({
      "token": newToken,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF4169E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FF),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Generate QR",
          style: TextStyle(color: Color(0xFF4169E1), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Please choose access type:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              RadioListTile<String>(
                title: const Text(
                  "Read data access",
                  style: TextStyle(color: Colors.white),
                ),
                value: "Read data access",
                groupValue: _selectedOption,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text(
                  "Confirm only access",
                  style: TextStyle(color: Colors.white),
                ),
                value: "Confirm only access",
                groupValue: _selectedOption,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: screenWidth * 0.8,
                height: 55,
                child: ElevatedButton(
                  onPressed: _sendGenerateQRRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F8FF),
                    foregroundColor: const Color(0xFF4169E1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Generate",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_qrData != null)
                ClipRRect(
                  child: QrImageView(
                    data: _qrData!,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
