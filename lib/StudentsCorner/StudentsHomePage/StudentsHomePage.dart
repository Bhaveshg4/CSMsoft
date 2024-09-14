import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentsCorner/Drawer/Drawer.dart';
import 'package:flutter_application_1/StudentsCorner/PurchasedCourses/PurchasedCourses.dart';
import 'package:flutter_application_1/StudentsCorner/MyCourses/MyCourses.dart';
import 'package:flutter_application_1/StudentsCorner/Quizes.dart';
import 'package:flutter_application_1/StudentsCorner/StudentsHomePage/supportHomePageStudent.dart';

class StudentsHomePage extends StatelessWidget {
  const StudentsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          "Student Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      drawer: MyWidget(), // The custom Drawer widget
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to your dashboard!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ResponsiveCard(
              title: 'My Courses',
              description: 'Browse and manage all your enrolled courses.',
              icon: Icons.book,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyCoursesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ResponsiveCard(
              title: 'My Quizzes',
              description: 'Test your knowledge with course quizzes.',
              icon: Icons.question_answer,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyQuizzesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ResponsiveCard(
              title: 'Purchased Courses',
              description:
                  'All in one place to learn courses which you have purchased',
              icon: Icons.notifications,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LatestCourse(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
