import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthorityCorner/FeatureContainerAuthortityHome.dart';
import 'package:flutter_application_1/StudentsCorner/NewCourse/NewCourse.dart';
import 'package:flutter_application_1/AuthorityCorner/UploadQuiz.dart';

class AuthorityHomePage extends StatelessWidget {
  const AuthorityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          "Authority Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B), // Gradient color part 1
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildFeatureContainer(
                icon: Icons.upload,
                text: "Upload a New Course",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadCoursePage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildFeatureContainer(
                icon: Icons.change_circle,
                text: "Upload Quiz",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadQuiz()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
