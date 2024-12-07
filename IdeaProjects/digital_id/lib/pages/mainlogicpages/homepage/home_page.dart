import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../domain/models/current_user.dart';
import '../generateqr/generate_qr_page.dart';
import '../readqr/read_qr_page.dart';


class HomePage extends StatefulWidget {
  final CurrentUser currentUser;

  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Индекс текущей страницы

  // Список страниц
  List<Widget> _getPages() {
    return [
      GenerateQRPage(
        currentUser: widget.currentUser,
      ), // Страница для генерации QR
      ReadQRPage(
        currentUser: widget.currentUser,
      ), // Страница для считывания QR
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages();

    return Scaffold(
      backgroundColor: const Color(0xFF4169E1),
      body: pages[_selectedIndex], // Отображаем текущую страницу
      bottomNavigationBar: Container(
        color: const Color(0xFFF8F8FF),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 5,
          ),
          child: GNav(
            backgroundColor: const Color(0xFFF8F8FF),
            color: const Color(0xFF4169E1),
            activeColor: const Color(0xFF4169E1),
            tabBackgroundColor: const Color(0xFFD7D7D7),
            gap: 10,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Обновляем текущий индекс
              });
            },
            tabs: const [
              GButton(
                icon: Icons.add_box_outlined,
                text: 'Generate QR',
                iconSize: 30,
              ),
              GButton(
                icon: Icons.qr_code_scanner,
                text: 'Read QR',
                iconSize: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
