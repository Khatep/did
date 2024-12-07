import 'package:digital_id/pages/mainlogicpages/homepage/home_page.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/current_user.dart';
import '../../../mainlogicpages/generateqr/generate_qr_page.dart';

class ViewSuccessResult extends StatelessWidget {
  final CurrentUser currentUser;

  const ViewSuccessResult({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Переход на HomePage: GenerateQRPage при нажатии кнопки "Назад"
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage(currentUser: currentUser,)),
              (route) => false, // Удалить все предыдущие маршруты из стека
        );
        return false; // Блокируем стандартное поведение кнопки "Назад"
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4169E1), // Фон страницы
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F8FF), // Цвет фона AppBar
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Success",
            style: TextStyle(
              color: Color(0xFF4169E1),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline, // Иконка успеха
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                "Data is valid",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Переход на HomePage
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage(currentUser: currentUser,)),
                        (route) => false, // Удалить все предыдущие маршруты из стека
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F8FF), // Цвет кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(
                    color: Color(0xFF4169E1), // Цвет текста кнопки
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
