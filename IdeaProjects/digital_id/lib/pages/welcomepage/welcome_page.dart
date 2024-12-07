import 'package:digital_id/pages/loginpage/login_page.dart';
import 'package:flutter/material.dart';

import '../signuppage/signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFF4169E1), // Фон страницы
        child: SafeArea(
          child: Column(
            children: [
              // Верхний текст
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0, top: 45.0),
                child: Text(
                  'Digital ID',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF8F8FF), // Цвет текста
                  ),
                ),
              ),

              // Изображение по центру
              Center(
                child: Image.asset(
                  'assets/images/logo2.png', // Убедитесь, что путь к изображению верный
                  width: 200, // Можно указать желаемый размер
                  height: 200,
                ),
              ),
              const Spacer(),

              // Группа кнопок и текста
              Column(
                mainAxisSize: MainAxisSize.min, // Минимальная высота
                children: [
                  // Кнопка Sign Up
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: screenWidth * 0.8, // 80% ширины экрана
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF8F8FF), // Фон кнопки
                          foregroundColor: const Color(0xFF4169E1), // Цвет текста кнопки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Текст "Already have an account?"
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFF8F8FF), // Цвет текста
                      ),
                    ),
                  ),

                  // Кнопка Login
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0), // Отступ снизу
                    child: SizedBox(
                      width: screenWidth * 0.8, // 70% ширины экрана
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Обработчик нажатия Login TODO
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF8F8FF), // Фон кнопки
                          foregroundColor: const Color(0xFF4169E1), // Цвет текста кнопки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
