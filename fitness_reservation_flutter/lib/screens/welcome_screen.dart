import 'package:flutter/material.dart';

// Demonstrates Navigator.push() and pop() (Requirement 1)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade400, Colors.teal.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Fitness Class Reservation',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Book your fitness classes with ease',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Demonstrates Navigator.push() (Requirement 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DemoPushPopScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                    ),
                    child: const Text('Demo: Push/Pop Navigation'),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Demo screen for push/pop (Requirement 1)
class DemoPushPopScreen extends StatelessWidget {
  const DemoPushPopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push/Pop Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This screen was pushed using Navigator.push()',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Demonstrates Navigator.pop() (Requirement 1)
                Navigator.pop(context);
              },
              child: const Text('Go Back (pop)'),
            ),
          ],
        ),
      ),
    );
  }
}
