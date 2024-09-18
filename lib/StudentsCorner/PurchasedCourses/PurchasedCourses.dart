import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define the PurchasedCourse class
class PurchasedCourse {
  final String id; // Firestore document ID
  final String name;
  final String description;

  PurchasedCourse(this.id, this.name, this.description);
}

// Define the LatestCourse widget
class LatestCourse extends StatelessWidget {
  const LatestCourse({super.key});

  Future<List<PurchasedCourse>> fetchCourses() async {
    // Fetch courses from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('purchased_courses').get();
    return snapshot.docs.map((doc) {
      return PurchasedCourse(doc.id, doc['name'], doc['description']);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          "Purchased Courses",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: FutureBuilder<List<PurchasedCourse>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching courses"));
          }
          final courses = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: courses[index]);
            },
          );
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

  Future<List<Map<String, dynamic>>> fetchModules(String courseId) async {
    // Fetch modules for a specific course from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('purchased_courses')
        .doc(courseId)
        .collection('modules')
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc['id'],
        'name': doc['name'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          course.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchModules(course.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching modules"));
          }
          final modules = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return ModuleCard(module: modules[index]);
            },
          );
        },
      ),
    );
  }
}

// Define the ModuleCard widget
class ModuleCard extends StatelessWidget {
  final Map<String, dynamic> module;

  const ModuleCard({required this.module, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        module['name'],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
