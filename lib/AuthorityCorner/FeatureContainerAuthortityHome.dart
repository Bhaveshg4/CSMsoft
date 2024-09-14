import 'package:flutter/material.dart';

// Reusable widget to build the feature containers
Widget buildFeatureContainer({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF28313B), Color(0xFF485461)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, color: Colors.white),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const Icon(
            Icons.arrow_circle_right_rounded,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    ),
  );
}
