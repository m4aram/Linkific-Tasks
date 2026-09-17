import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _notificationsEnabled = true;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onInputChanged);
    _emailController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    if (_isSubmitted) {
      setState(() {
        _isSubmitted = false;
      });
    }
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form submitted for ${_nameController.text.trim()}'),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onInputChanged);
    _emailController.removeListener(_onInputChanged);
    _nameController.dispose();
    _emailController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'User Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'This form demonstrates controllers, focus management, validation, and state changes.',
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                nextFocusNode: _emailFocusNode,
                label: 'Name',
                hint: 'Enter your name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable notifications'),
                subtitle: Text(
                  _notificationsEnabled
                      ? 'Notifications are enabled'
                      : 'Notifications are disabled',
                ),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              if (_isSubmitted)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Submitted Successfully',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Name: ${_nameController.text}'),
                        Text('Email: ${_emailController.text}'),
                        Text(
                          'Notifications: '
                          '${_notificationsEnabled ? 'Enabled' : 'Disabled'}',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
