import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Gradient gradient;
  final VoidCallback onPressed;

  const GlassButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.gradient,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      child: Glassmorphism(
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          icon: Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
          label: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center text vertically
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 24, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center-align text horizontally
              ),
              const SizedBox(
                  height: 8), // Adjusted spacing between label and description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14, // Adjusted font size
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center, // Center-align text horizontally
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Glassmorphism extends StatelessWidget {
  final Widget child;

  const Glassmorphism({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
