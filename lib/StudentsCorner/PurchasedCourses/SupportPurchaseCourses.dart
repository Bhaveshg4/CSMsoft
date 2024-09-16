import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentsCorner/PurchasedCourses/moduleDetailPage.dart';

// Dummy data for modules
List<Map<String, dynamic>> modules = [
  {
    'id': 1,
    'name': 'Introduction to Flutter',
    'description':
        'Learn the basics of Flutter and how to set up your environment.',
  },
  {
    'id': 2,
    'name': 'Widgets and Layouts',
    'description':
        'Explore various widgets and learn how to create complex layouts.',
  },
  {
    'id': 3,
    'name': 'State Management',
    'description':
        'Understand state management and its importance in Flutter applications.',
  },
];

// Module List Page
class ModuleListPage extends StatelessWidget {
  const ModuleListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Modules'),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return ModuleCard(module: modules[index]);
        },
      ),
    );
  }
}

// Module Card UI
class ModuleCard extends StatelessWidget {
  final Map<String, dynamic> module;

  const ModuleCard({required this.module, Key? key}) : super(key: key);

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
          Text(
            'Module ${module['id']}: ${module['name']}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailPage(
                    module: module,
                    currentIndex: modules.indexOf(module),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
            ),
            child: const Text("Start Course"),
          ),
        ],
      ),
    );
  }
}
