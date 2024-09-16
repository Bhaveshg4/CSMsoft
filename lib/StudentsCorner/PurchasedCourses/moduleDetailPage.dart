import 'package:flutter/material.dart';
import 'package:flutter_application_1/StudentsCorner/PurchasedCourses/SupportPurchaseCourses.dart';

// Module Detail Page with progress bar
class ModuleDetailPage extends StatelessWidget {
  final Map<String, dynamic> module;
  final int currentIndex;

  const ModuleDetailPage({
    required this.module,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / modules.length;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          'Module ${module['id']}: ${module['name']}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF28313B),
      ),
      body: Column(
        children: [
          // Progress Bar at the top
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: ${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white),
                ),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white30,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module Heading
                    Text(
                      'Module ${module['id']}: ${module['name']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 13, 13),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Aesthetic Icon (Replaces Image)
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.book,
                        size: 80,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Module Content (Coursera-like Readable UI)

                    const SizedBox(height: 20),

                    // Bullet Points or Submodules
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• पाणिनीयम् अष्टाध्यायी: पाणिनिः संस्कृतव्याकरणस्य सर्वोत्तमं ग्रन्थं विरचितवान्। अस्य ग्रन्थस्य सूत्राणि ३९५९ सन्ति। अष्टाध्याय्यां पाणिनिः सङ्कीर्णसूत्रैः शब्दनिर्माणं, प्रत्ययानां प्रयोगं च निरूपयति। एषा व्याकरणशास्त्रस्य परिष्कृततमः अध्ययनविधिः अस्ति।',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• मीमांसाशास्त्रे वेदानां विधीनां तत्त्वज्ञानं विवेच्यते। द्वे शाखे अस्ति—पूर्वमीमांसा यः धर्मस्य अन्वेषणं करोति, उत्तरमीमांसा वा वेदान्तः यः मोक्षस्य विचारं करोति।',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• षड्दर्शनानि—न्यायः, वैशेषिकः, सांख्यः, योगः, पूर्वमीमांसा, उत्तरमीमांसा वा वेदान्तः—अत्र दार्शनिकं ज्ञानं प्रतिपाद्यते। आत्मा, मोक्षः, प्रकृतिः, पुरुषः इत्यादीनां विचारः अत्र क्रीडति।',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                    // "Mark as Complete" or Next Step Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to next module if available
                          if (currentIndex < modules.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModuleDetailPage(
                                  module: modules[currentIndex + 1],
                                  currentIndex: currentIndex + 1,
                                ),
                              ),
                            );
                          } else {
                            // If no more modules, show completion message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Course Completed'),
                                content: const Text(
                                    'You have completed all modules!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(
                                          context); // Back to module list
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: Text(
                          (currentIndex < modules.length - 1)
                              ? 'Next Module'
                              : 'Finish Course',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
