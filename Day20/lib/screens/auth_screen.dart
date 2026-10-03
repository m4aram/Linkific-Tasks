import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

/// ConsumerStatefulWidget = a StatefulWidget that also has `ref`.
/// We need State here for the form key and the text controllers.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    // ref.listen: one-time side effect when the state changes (no rebuild).
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.status == AuthStatus.loading && next.status == AuthStatus.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome back!')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      // The UI is a function of the auth state.
      body: auth.isLoggedIn ? _profile(context, auth) : _form(context, auth),
    );
  }

  Widget _profile(BuildContext context, AuthState auth) {
    final user = auth.user!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 16),
        Text(user.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
        Text(user.email, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        const Card(
          child: ListTile(
            leading: Icon(Icons.local_offer_outlined),
            title: Text('Member discount active'),
            subtitle: Text('10% off in the shop. cartSummaryProvider recalculates because it watches isMemberProvider.'),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => ref.read(authProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
        ),
      ],
    );
  }

  Widget _form(BuildContext context, AuthState auth) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Log in', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Demo account:  demo@example.com  /  123456'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
          ),
          const SizedBox(height: 16),
          if (auth.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(auth.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          FilledButton(
            onPressed: auth.isLoading ? null : _login,
            child: auth.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Log in'),
          ),
        ],
      ),
    );
  }
}
