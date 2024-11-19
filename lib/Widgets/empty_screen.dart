import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {

  final String title;
  final IconData displayIcon;
  final String? descriptionText;

  const EmptyScreen({
    super.key, 
    required this.title, 
    required this.displayIcon,
    this.descriptionText
    });
    

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                color: Color(0xFF1DB954),
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
             Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                descriptionText ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}