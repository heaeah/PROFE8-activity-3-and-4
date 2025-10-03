import 'package:flutter/material.dart';

// Named route example (Requirement 7)
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 24),
            const Text(
              'Fitness Class Reservation',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'About This App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This app demonstrates comprehensive Flutter navigation patterns and form handling, including:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem('Navigator push() and pop()'),
            _buildFeatureItem('Drawer menu navigation'),
            _buildFeatureItem('Bottom navigation bar'),
            _buildFeatureItem('TabBar with TabBarView'),
            _buildFeatureItem('Named routes'),
            _buildFeatureItem('Form validation'),
            _buildFeatureItem('Date and time pickers'),
            _buildFeatureItem('Local data storage'),
            const SizedBox(height: 32),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem('User registration and login'),
            _buildFeatureItem('Book fitness classes'),
            _buildFeatureItem('View booking history'),
            _buildFeatureItem('Multiple class types'),
            _buildFeatureItem('Skill level selection'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
