import 'package:flutter/material.dart';

class LoginAnimationScreen extends StatefulWidget {
  const LoginAnimationScreen({super.key});

  @override
  State<LoginAnimationScreen> createState() => _LoginAnimationScreenState();
}

class _LoginAnimationScreenState extends State<LoginAnimationScreen> {
  bool showLogin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        showLogin = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Login')),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        opacity: showLogin ? 1 : 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(showLogin ? 24 : 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 70, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
