import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../domain/models/current_user.dart';
import 'package:logger/logger.dart';

import '../qrresult/viewsuccessresult/view_success_result.dart';
import '../qrresult/viewuserdata/view_user_data.dart';

class ReadQRPage extends StatefulWidget {
  final CurrentUser currentUser;

  const ReadQRPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ReadQRPage> createState() => _ReadQRPageState();
}

class _ReadQRPageState extends State<ReadQRPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  Map<String, dynamic>? userData; // Для хранения данных пользователя
  final Logger _logger = Logger(); // Инициализация логера
  bool _isProcessing = false;

  get currentUser => widget.currentUser;

  @override
  void dispose() {
    _logger.i("Disposing QRViewController");
    _controller?.dispose();
    super.dispose();
  }

  // Функция для отправки запроса с токеном на сервер
  Future<void> sendToken(String token) async {
    _logger.d("sendToken called with token: $token");

    final url = Uri.parse('http://mbp-yernurskiy.netbird.cloud:8080/api/v1/qr/read-token');
    final publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt0vo8b9V2jHY6vWVkP9ayk/p4jwCtuhNcpbM1pGrrW1t80rv2niq92Jmr5PzMJm2Z9X027svuzgp3Sd+2a8y3UQPfVFMLf0d96DOQTcn1FLGv1BOjkVDuN0nTAc9jb97If9lxuVafqNZcy6hZXQqnw5CBXvqnJ7y+BcW3ylbP7aXFGi/ehLINZQuQNZXYC0R0ndwtI7ekSrw1rk0wjhRQnU5QKdWr+elsQXvfbaf7noV0nNp7xpEuGjrEhXt6JfQJOF3flAkOrBbt2u62tude/4VyUaVEBmUBDnrTPy6VZIzQ2zId7JtyvHZRWyrA7ACUtXTgivLf73sEY8/FYVepwIDAQAB";

    final headers = {
      'Authorization': 'Bearer ${widget.currentUser.token}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'token': token,
      'publicKey': publicKey,
    });

    try {
      _logger.i("Sending request to $url and with $body");
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        _logger.i("Token sent successfully. Response: ${response.body}");
        final responseData = jsonDecode(response.body);

        if (responseData['isDataValid'] == true) {
          if (responseData.containsKey('userDidDto')) {
            setState(() {
              userData = responseData['userDidDto'];
            });
            _logger.d("Navigating to ViewUserData with userData: $userData");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewUserData(userData: userData!, currentUser: currentUser,),
              ),
            );
          } else {
            _logger.d("Navigating to ViewSuccessResult");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewSuccessResult(currentUser: currentUser,),
              ),
            );
          }
        } else {
          _logger.w("Data is not valid.");
          await _controller?.resumeCamera(); // Возобновляем камеру при невалидных данных
        }
      } else {
        _logger.w("Failed to send token. Status code: ${response.statusCode}");
        await _controller?.resumeCamera(); // Возобновляем камеру при ошибке сервера
      }
    } catch (e, stackTrace) {
      _logger.e("Error during token send: $e", e, stackTrace);
      await _controller?.resumeCamera(); // Возобновляем камеру при ошибке
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    _logger.d("QRView created");
    setState(() {
      _controller = controller;
    });

    // Слушатель сканированных данных
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing) {
        // Если уже обрабатываем скан, игнорируем остальные
        return;
      }
      _isProcessing = true; // Устанавливаем флаг

      _logger.i("Scanned QR Code: ${scanData.code}");
      try {
        // Пауза сканера, чтобы дождаться результата обработки
        await _controller?.pauseCamera();

        final Map<String, dynamic> scannedData = jsonDecode(scanData.code ?? "");
        String validCode = scannedData["token"];
        _logger.i("Extracted token: $validCode");

        // Отправляем токен на сервер
        await sendToken(validCode);
      } catch (e) {
        _logger.e("Failed to parse QR Code: $e");
      } finally {
        _isProcessing = false; // Сбрасываем флаг после обработки
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.d("Building ReadQRPage");
    return Scaffold(
      backgroundColor: const Color(0xFF4169E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Read QR",
          style: TextStyle(
              color: Color(0xFF4169E1),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // QR Code Scanner
          // QR Code Scanner
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated, // Используем обновленный метод
          ),
          // Полупрозрачная затемнённая область
          ClipPath(
            clipper: _ScannerOverlayClipper(), // Форма выреза
            child: Container(
              color: Colors.black.withOpacity(0.6), // Прозрачный чёрный
            ),
          ),
          // Текст "Сканируйте QR-код"
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Scan QR",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Угловая рамка
          Center(
            child: CustomPaint(
              size: const Size(250, 250), // Размер рамки
              painter: _CornerPainter(color: const Color(0xFF4169E1)), // Цвет рамок
            ),
          ),
        ],
      ),
    );
  }
}

// Рисуем углы рамки
class _CornerPainter extends CustomPainter {
  final Color color;

  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;

    // Верхний левый угол
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // Верхний правый угол
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Нижний левый угол
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Нижний правый угол
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Вырезаем прозрачный квадрат для сканера
class _ScannerOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scanSize = 250.0;

    // Вырезаем центр
    path.addRect(Rect.fromLTWH(
      (size.width - scanSize) / 2, // Центрирование по горизонтали
      (size.height - scanSize) / 2, // Центрирование по вертикали
      scanSize,
      scanSize,
    ));

    // Обводка только снаружи
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
