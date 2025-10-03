import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bookings_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import '../services/app_data.dart';

// Main app with Drawer + BottomNavigationBar (Requirements 2, 3, 5, 6, 10)
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Reservation'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      // Drawer menu with three pages (Requirement 2)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppData.currentUser?.username ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppData.currentUser?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Bookings'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            const Divider(),

            // Named routes (Requirement 7)
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                AppData.currentUser = null;
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),

      body: _screens[_currentIndex],

      // BottomNavigationBar with icons (Requirements 3, 5)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
