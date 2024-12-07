import 'package:flutter/material.dart';

import '../../../../domain/models/current_user.dart';
import '../../../mainlogicpages/homepage/home_page.dart';

class ViewUserData extends StatelessWidget {
  final Map<String, dynamic> userData;
  final CurrentUser currentUser;

  const ViewUserData({Key? key, required this.userData, required this.currentUser}) : super(key: key);

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
          backgroundColor: const Color(0xFF4169E1),
          appBar: AppBar(
            title: const Center(
              child: Text(
                "User Data",
                style: TextStyle(
                  color: Color(0xFF4169E1),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            backgroundColor: const Color(0xFFF8F8FF),
            iconTheme: const IconThemeData(color: Color(0xFF4169E1)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 25.0, right: 16.0, left: 16.0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'First name: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['firstname']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Last name: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['lastname']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Middle name: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['surname']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Birthdate: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['birthdate']?.substring(0, 10)}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'IIN: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['iin']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Document Number: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['documentNumber']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Issuer: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['issuer']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Nation: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['nation']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Issue Date: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['issueDate']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Expiry Date: ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${userData['expiryDate']}',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Переход на HomePage
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomePage(currentUser: currentUser),
                        ),
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
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        )
    );
  }
}
