import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  Future<void> register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      setState(() => loading = true);

      await authService.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Create Account'),),
      body: Padding(
        padding: const EdgeInsets.all(20), child: Column(children: [ TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email',),),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        ),

        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: loading ? null : register,
          child: Text(
            loading ? 'Creating...' : 'Create Account',
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back to Login'),
        ),
      ],
      ),
      ),
    );
  }
}