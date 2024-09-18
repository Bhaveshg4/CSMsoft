import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentsCorner/StudentsHomePage/StudentsHomePage.dart';

class MyQuizzesPage extends StatefulWidget {
  const MyQuizzesPage({super.key});

  @override
  State<MyQuizzesPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<MyQuizzesPage> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  String? _selectedCourse;
  bool _isQuizStarted = false;

  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _questions = [];
  final Map<int, String> _selectedAnswers = {};

  bool get _isQuizComplete => _selectedAnswers.length == _questions.length;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courseCollection = FirebaseFirestore.instance.collection('courses');
      final querySnapshot = await courseCollection.get();
      final courses = querySnapshot.docs.map((doc) {
        return {
          'courseId': doc.id,
          'courseName': doc['courseName'],
          'description': doc['description'],
          'rating': doc['rating'],
          'duration': doc['duration']
        };
      }).toList();
      setState(() {
        _courses = courses;
      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Future<void> _fetchQuestions(String courseId) async {
    try {
      final questionCollection = FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('questions');
      final querySnapshot = await questionCollection.get();
      final questions = querySnapshot.docs.map((doc) {
        return {
          'question': doc['questionText'],
          'options': [
            doc['options']['option1'],
            doc['options']['option2'],
            doc['options']['option3'],
            doc['options']['option4'],
          ],
          'correctOption': doc['correctOption'],
        };
      }).toList();
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  void _startQuiz() async {
    if (_selectedCourse != null) {
      final selectedCourseId = _courses.firstWhere(
          (course) => course['courseName'] == _selectedCourse)['courseId'];
      await _fetchQuestions(selectedCourseId);
      if (_questions.isNotEmpty) {
        setState(() {
          _isQuizStarted = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No questions available for this course."),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a course to start the quiz"),
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _pageController.animateToPage(
        _currentQuestionIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _pageController.animateToPage(
        _currentQuestionIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectAnswer(int questionIndex, String answer) {
    setState(() {
      _selectedAnswers[questionIndex] = answer;
    });
  }

  void _completeQuiz() {
    if (!_isQuizComplete) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Incomplete Test"),
            content: const Text("Please solve the whole test."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Congratulations!"),
            content: const Text(
                "Test completed successfully! We will email you the results."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentsHomePage(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isQuizStarted ? "Quiz on $_selectedCourse" : "Select a Course",
          style: const TextStyle(color: Colors.white),
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
        child: _isQuizStarted ? _buildQuizPage() : _buildCourseSelectionPage(),
      ),
    );
  }

  Widget _buildCourseSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select a course to start the quiz:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          for (var course in _courses)
            ListTile(
              title: Text(
                course['courseName'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Rating: ${course['rating']} | Duration: ${course['duration']}",
                style: const TextStyle(color: Colors.white70),
              ),
              leading: Radio<String>(
                value: course['courseName'],
                groupValue: _selectedCourse,
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value;
                  });
                },
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF485461),
              ),
              onPressed: _startQuiz,
              child: const Text(
                "Start Quiz",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPage() {
    return Column(
      children: [
        if (_questions.isNotEmpty)
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF485461)),
          ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return _buildQuestionPage(index);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28313B),
                  ),
                  onPressed: _previousPage,
                  child: const Icon(Icons.arrow_back),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF485461),
                ),
                onPressed: _currentQuestionIndex < _questions.length - 1
                    ? _nextPage
                    : _completeQuiz,
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? "Next"
                      : "Submit",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPage(int questionIndex) {
    final question = _questions[questionIndex];
    final selectedAnswer = _selectedAnswers[questionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${questionIndex + 1}/${_questions.length}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          for (var option in question['options'])
            ListTile(
              title: Text(
                option,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Radio<String>(
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  _selectAnswer(questionIndex, value!);
                },
              ),
            ),
        ],
      ),
    );
  }
}
