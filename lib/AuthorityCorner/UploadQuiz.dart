import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadQuiz extends StatefulWidget {
  const UploadQuiz({super.key});

  @override
  _UploadQuizState createState() => _UploadQuizState();
}

class _UploadQuizState extends State<UploadQuiz> {
  final List<Map<String, dynamic>> _questions = List.generate(
      5,
      (index) => {
            'question': TextEditingController(),
            'options': List.generate(4, (_) => TextEditingController()),
            'correct': TextEditingController(),
          });

  final TextEditingController _courseNameController = TextEditingController();
  bool _isUploading = false;

  Future<void> _uploadQuiz() async {
    if (_courseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course name')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Create a reference to the course collection
      final courseRef = FirebaseFirestore.instance
          .collection('courses')
          .doc(_courseNameController.text);

      // Add questions to the course's 'questions' sub-collection
      for (var question in _questions) {
        await courseRef.collection('questions').add({
          'question': question['question'].text,
          'options':
              question['options'].map((controller) => controller.text).toList(),
          'correct': question['correct'].text,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz uploaded successfully!')),
      );

      // Clear fields after uploading
      _courseNameController.clear();
      for (var question in _questions) {
        question['question'].clear();
        for (var optionController in question['options']) {
          optionController.clear();
        }
        question['correct'].clear();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading quiz: $error')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Quiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28313B), Color(0xFF485461)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(index);
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF485461),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Upload Quiz',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    return Card(
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: question['question'],
              decoration: const InputDecoration(
                labelText: 'Enter question',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < 4; i++)
              TextField(
                controller: question['options'][i],
                decoration: InputDecoration(
                  labelText: 'Option ${i + 1}',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: question['correct'],
              decoration: const InputDecoration(
                labelText: 'Enter correct option',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
