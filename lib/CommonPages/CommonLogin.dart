import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthorityCorner/AuthoLogin/AuthorityLogin.dart';
import 'package:flutter_application_1/CommonPages/SupportCommonPages.dart';
import 'package:flutter_application_1/StudentsCorner/StudentsLogin.dart';

class CommonLogin extends StatelessWidget {
  const CommonLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28313B), Color(0xFF485461)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Student Button
              GlassButton(
                icon: Icons.school_rounded,
                label: 'Login as Student',
                description: 'Access your courses and track your progress.',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentsLogin(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Authority Button
              GlassButton(
                icon: Icons.person_rounded,
                label: 'Login as Authority',
                description: 'Manage courses and oversee student progress.',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF03A9F4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthorityLogin(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "About Us",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
