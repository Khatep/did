import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../domain/models/current_user.dart';
import '../mainlogicpages/homepage/home_page.dart';

class InputDataFormPage extends StatefulWidget {
  final CurrentUser currentUser;

  const InputDataFormPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _InputDataFormPageState createState() => _InputDataFormPageState();
}

class _InputDataFormPageState extends State<InputDataFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _iinController = TextEditingController();
  final TextEditingController _docNumberController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _nationController = TextEditingController();
  final TextEditingController _issuedDateController = TextEditingController();
  final TextEditingController _expiredDateController = TextEditingController();
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  // Логгер
  final Logger _logger = Logger();

  // Метод для выбора даты
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    _logger.d('Opening date picker for field: ${controller.text}');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
      _logger.d('Selected date: ${controller.text}');
    } else {
      _logger.d('Date picker cancelled');
    }
  }

  // Метод для отправки данных на сервер
  Future<void> _submitDataToBackend() async {
    final String url = 'http://mbp-yernurskiy.netbird.cloud:8080/api/v1/qr/createDid';

    final Map<String, dynamic> data = {
      "firstname": _firstNameController.text,
      "lastname": _surnameController.text,
      "surname": _middleNameController.text,
      "birthdate": _dobController.text,
      "iin": _iinController.text,
      "documentNumber": _docNumberController.text,
      "issuer": _issuerController.text,
      "nation": _nationController.text,
      "issueDate": _issuedDateController.text,
      "expiryDate": _expiredDateController.text,
    };

    _logger.i('Attempting to submit data: $data');

    try {
      _setLoading(true);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.currentUser.token}',
        },
        body: jsonEncode(data),
      );

      _logger.i('Response received: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('Data submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data submitted successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: widget.currentUser)),
        );
      } else {
        _logger.e('Failed to submit data: ${response.body}');
        _showError('Failed to submit data: ${response.body}');
      }
    } catch (e, stacktrace) {
      _logger.e('An error occurred during data submission', e, stacktrace);
      _showError('An error occurred: $e');
      _setLoading(false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4169E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4169E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFFF8F8FF),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fill the form below",
          style: TextStyle(
            color: Color(0xFFF8F8FF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildInputField("First name", _firstNameController),
                const SizedBox(height: 16),
                _buildInputField("Surname", _surnameController),
                const SizedBox(height: 16),
                _buildInputField("Middle name", _middleNameController),
                const SizedBox(height: 16),
                _buildDateField("Date of birth", _dobController),
                const SizedBox(height: 16),
                _buildInputField("IIN", _iinController, isNumber: true),
                const SizedBox(height: 16),
                _buildInputField("Document number", _docNumberController, isNumber: true),
                const SizedBox(height: 16),
                _buildInputField("Issuer", _issuerController),
                const SizedBox(height: 16),
                _buildInputField("Nation", _nationController),
                const SizedBox(height: 16),
                _buildDateField("Issued date", _issuedDateController),
                const SizedBox(height: 16),
                _buildDateField("Expired date", _expiredDateController),
                const SizedBox(height: 32),

                if (_isLoading)
                  const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8F8FF))
                      )
                  )
                else SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitDataToBackend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F8FF),
                      foregroundColor: const Color(0xFF4169E1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xFFF8F8FF),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Color(0xFFF8F8FF)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFF8F8FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      style: const TextStyle(color: Color(0xFFF8F8FF)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFF8F8FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF8F8FF)),
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFFF8F8FF)),
      ),
    );
  }

  void _showError(String message) {
    _logger.w('Error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
