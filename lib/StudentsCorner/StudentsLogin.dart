import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/StudentsCorner/StudentsHomePage/StudentsHomePage.dart';
import 'package:flutter_application_1/StudentsCorner/Register/StudentsRegister.dart';

const LinearGradient backgroundGradient = LinearGradient(
  colors: [Color(0xFF28313B), Color(0xFF485461)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class StudentsLogin extends StatefulWidget {
  const StudentsLogin({super.key});

  @override
  _StudentsLoginState createState() => _StudentsLoginState();
}

class _StudentsLoginState extends State<StudentsLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginStudent() async {
    try {
      // Query Firestore for a document with the entered email
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: _emailController.text)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final studentData = snapshot.docs.first.data();

        // Check if the password matches
        if (studentData['password'] == _passwordController.text) {
          // Password matches, navigate to StudentsHomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentsHomePage(),
            ),
          );
        } else {
          // Incorrect password, show error message
          _showErrorDialog('Incorrect password, please try again.');
        }
      } else {
        // No user found with this email, show registration message
        _showErrorDialog(
            'You are not registered yet, please register yourself.');
      }
    } catch (e) {
      // If there's an error (like no internet), show the error
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login As Student",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: backgroundGradient,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email TextField with Icon
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password TextField with Icon
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Login Button with modern UI
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _loginStudent(); // Validate the form and login
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black.withOpacity(0.5),
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28313B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigate to Registration Page
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentRegister(),
                        ),
                      );
                    },
                    child: const Text(
                      "Not registered yet? Register Now!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for building advanced TextFormFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        prefixIcon: Icon(icon, color: const Color(0xFF28313B)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF28313B),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      ),
      validator: validator,
      style: const TextStyle(color: Colors.black),
    );
  }
}
