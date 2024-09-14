import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentsCorner/PurchasedCourses/SupportPurchaseCourses.dart';

// Define the PurchasedCourse class
class PurchasedCourse {
  final String name;
  final String description;

  PurchasedCourse(this.name, this.description);
}

// Define the LatestCourse widget
class LatestCourse extends StatelessWidget {
  const LatestCourse({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for purchased courses
    final courses = [
      PurchasedCourse('Course 1', 'Learn Flutter from scratch.'),
      PurchasedCourse('Course 2', 'Master advanced Dart concepts.'),
      PurchasedCourse('Course 3', 'Explore state management in Flutter.'),
    ];

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          "Purchased Courses",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseCard(course: courses[index]);
        },
      ),
    );
  }
}

// Define the CourseCard widget
class CourseCard extends StatelessWidget {
  final PurchasedCourse course;

  const CourseCard({required this.course, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28313B), Color(0xFF485461)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.done, color: Colors.green, size: 30),
              const SizedBox(width: 10),
              Text(
                course.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            course.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(course: course),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: const Text("Resume Course"),
            ),
          ),
        ],
      ),
    );
  }
}

// Define the CourseDetailPage widget
class CourseDetailPage extends StatelessWidget {
  final PurchasedCourse course;

  const CourseDetailPage({required this.course, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for course modules
    final modules = [
      {'id': 1, 'name': 'Introduction to ${course.name}'},
      {'id': 2, 'name': 'Module 1: Getting Started'},
      {'id': 3, 'name': 'Module 2: Advanced Concepts'},
      {'id': 4, 'name': 'Final Test'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return ModuleCard(module: modules[index]);
        },
      ),
    );
  }
}
