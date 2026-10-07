import 'package:flutter/material.dart';

import 'validators.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  void _submit() {
    setState(() {
      _isValid = _formKey.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('emailField'),
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.validateEmail,
              ),
              TextFormField(
                key: const Key('passwordField'),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              if (_isValid) const Text('Form is valid'),
            ],
          ),
        ),
      ),
    );
  }
}
