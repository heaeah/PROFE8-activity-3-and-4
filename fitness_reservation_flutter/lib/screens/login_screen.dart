import 'package:flutter/material.dart';
import '../services/app_data.dart';

// Login form with validation (Requirements 2, 3, 4)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Requirement 4
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final user = AppData.users.firstWhere(
          (u) => u.email == email && u.password == password,
        );

        AppData.currentUser = user;

        // Demonstrates pushReplacement (Requirement 8)
        Navigator.pushReplacementNamed(context, '/app');
      } catch (e) {
        // User not found or wrong password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field with validation (Requirement 3)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Email must contain @';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field with validation (Requirement 3)
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Demo: push vs pushReplacement (Requirement 8)
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Push vs PushReplacement'),
                        content: const Text(
                          'push(): Adds new screen to stack, can go back\n\n'
                          'pushReplacement(): Replaces current screen, cannot go back\n\n'
                          'After login, we use pushReplacement so users cannot go back to login screen.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it!'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Demo: push() vs pushReplacement()'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
