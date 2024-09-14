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

  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _answers = [];
  final Map<int, String> _selectedAnswers = {};

  bool get _isQuizComplete => _selectedAnswers.length == _questions.length;

  // Fetch questions for the selected course (limit to 5 questions)
  void _startQuiz() async {
    if (_selectedCourse != null) {
      setState(() {
        _isQuizStarted = true;
      });

      // Fetch exactly 5 questions for the selected course from Firestore
      final courseQuestions = await FirebaseFirestore.instance
          .collection('courses')
          .doc(_selectedCourse)
          .collection('questions')
          .limit(5)
          .get();

      setState(() {
        _questions = courseQuestions.docs.map((doc) => doc.data()).toList();
        _answers = _questions.map((question) {
          return {
            'correct': question['correct'],
            'options': question['options']
          };
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a course to start the quiz"),
        ),
      );
    }
  }

  // Navigate to next question
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

  // Navigate to previous question
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

  // Store selected answer for each question
  void _selectAnswer(int questionIndex, String answer) {
    setState(() {
      _selectedAnswers[questionIndex] = answer;
    });
  }

  // Complete quiz and submit data to Firebase
  void _completeQuiz() async {
    final selectedCourse = _selectedCourse; // Store the selected course name

    // Prepare the results to submit to Firebase
    List<Map<String, dynamic>> quizResults = [];
    for (int i = 0; i < _questions.length; i++) {
      quizResults.add({
        'question': _questions[i]['question'],
        'options': _answers[i]['options'],
        'selectedAnswer': _selectedAnswers[i],
        'correctAnswer': _answers[i]['correct'],
      });
    }

    // Save quiz results to Firestore under 'quizResults' collection
    await FirebaseFirestore.instance.collection('quizResults').add({
      'course': selectedCourse,
      'results': quizResults,
      'submittedAt': Timestamp.now(),
    });

    // Show completion message and navigate back to StudentsHomePage
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text(
              "Completed test successfully, we will be back soon with your results!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentsHomePage()));
              },
              child: const Text("OK"),
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
        title: Text(
          _isQuizStarted ? "Quiz on $_selectedCourse" : "Select a Course",
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
        child: _isQuizStarted ? _buildQuizPage() : _buildCourseSelectionPage(),
      ),
    );
  }

  Widget _buildCourseSelectionPage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading courses.'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No courses available.'));
        }

        final courses = snapshot.data!.docs.map((doc) => doc.id).toList();

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
              for (var course in courses)
                ListTile(
                  title: Text(
                    course,
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: Radio<String>(
                    value: course,
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
      },
    );
  }

  Widget _buildQuizPage() {
    return Column(
      children: [
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
                onPressed: _isQuizComplete ? _completeQuiz : _nextPage,
                child: _isQuizComplete
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPage(int index) {
    final question = _questions[index]['question'] as String;
    final answers = _answers[index]['options'] as List<String>;
    final selectedAnswer = _selectedAnswers[index];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          for (var answer in answers)
            ListTile(
              title: Text(
                answer,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Radio<String>(
                value: answer,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  if (value != null) {
                    _selectAnswer(index, value);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
