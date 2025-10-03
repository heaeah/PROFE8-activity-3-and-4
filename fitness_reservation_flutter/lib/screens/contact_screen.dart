import 'package:flutter/material.dart';

// Named route example (Requirement 7)
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                title: const Text('Email'),
                subtitle: const Text('support@fitnessapp.com'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: const Text('Phone'),
                subtitle: const Text('+1 (555) 123-4567'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: const Text('Address'),
                subtitle:
                    const Text('123 Fitness Street\nHealthy City, HC 12345'),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Send us a message',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
