import 'package:flutter/material.dart';
import '../services/app_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.teal.shade100,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.teal.shade700,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            user?.username ?? 'Guest',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.teal),
                  title: const Text('Total Bookings'),
                  trailing: Text(
                    '${AppData.bookings.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.teal),
                  title: const Text('Registered Users'),
                  trailing: Text(
                    '${AppData.users.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              AppData.currentUser = null;
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
