import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadCoursePage extends StatefulWidget {
  const UploadCoursePage({super.key});

  @override
  _UploadCoursePageState createState() => _UploadCoursePageState();
}

class _UploadCoursePageState extends State<UploadCoursePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String courseName = '';
  String courseDescription = '';
  String courseDuration = '';
  String coursePrice = '';
  late AnimationController _controller;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitCourse() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a course document in Firestore
      await FirebaseFirestore.instance.collection('courses').add({
        'title': courseName,
        'description': courseDescription,
        'duration': courseDuration,
        'price': int.parse(coursePrice), // Assuming the price is an integer
        'rating': 5, // Default rating or set a logic to allow user input
      });

      // Show success animation and navigate back
      setState(() {
        _showSuccess = true;
      });

      _controller.forward().whenComplete(() {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context); // Navigate back to AuthorityHomePage
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload a New Course",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28313B), Color(0xFF485461)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: _showSuccess ? _buildSuccessCard() : _buildFormCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return ScaleTransition(
      scale: _controller.drive(Tween<double>(begin: 1, end: 0.9)
          .chain(CurveTween(curve: Curves.easeInOut))),
      child: Card(
        key: const ValueKey('formCard'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 350,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter Course Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28313B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildAnimatedTextFormField(
                      "Course Name",
                      (value) => courseName = value!,
                    ),
                    const SizedBox(height: 16),
                    buildAnimatedTextFormField(
                      "Course Description",
                      (value) => courseDescription = value!,
                    ),
                    const SizedBox(height: 16),
                    buildAnimatedTextFormField(
                      "Duration (e.g., 6 weeks)",
                      (value) => courseDuration = value!,
                    ),
                    const SizedBox(height: 16),
                    buildAnimatedTextFormField(
                      "Price (in INR)",
                      (value) => coursePrice = value!,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return ScaleTransition(
      scale: _controller.drive(Tween<double>(begin: 0.9, end: 1)
          .chain(CurveTween(curve: Curves.easeInOut))),
      child: Card(
        key: const ValueKey('successCard'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: SizedBox(
            width: 350,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Uploaded Successfully!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF28313B),
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

  Widget buildAnimatedTextFormField(
    String labelText,
    FormFieldSetter<String> onSaved, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Color(0xFF28313B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF28313B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF485461), width: 2.0),
              ),
            ),
            onSaved: onSaved,
            validator: (value) =>
                value!.isEmpty ? 'Please enter $labelText' : null,
            keyboardType: keyboardType,
          ),
        );
      },
    );
  }

  Widget buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: _submitCourse,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + _controller.value * 0.05,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF28313B), Color(0xFF485461)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
