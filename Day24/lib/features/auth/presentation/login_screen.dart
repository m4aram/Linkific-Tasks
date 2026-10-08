import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoplite/core/constants/app_assets.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/utils/validators.dart';
import 'package:shoplite/core/widgets/app_text_field.dart';
import 'package:shoplite/core/widgets/primary_button.dart';
import 'package:shoplite/features/auth/logic/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Controllers and focus nodes hold native resources: always release.
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    await ref.read(authControllerProvider.notifier).login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
    // On success AuthGate swaps this screen out; nothing else to do here.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitting = ref.watch(
      authControllerProvider.select((state) => state.isSubmitting),
    );

    // Show errors once, as a snackbar, when they appear.
    ref.listen<String?>(
      authControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next)));
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          AppAssets.logo,
                          width: 88,
                          height: 88,
                          semanticsLabel: AppStrings.logoLabel,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        AppStrings.loginTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      AppTextField(
                        controller: _usernameController,
                        label: AppStrings.username,
                        hint: AppStrings.usernameHint,
                        prefixIcon: Icons.person_outline,
                        enabled: !isSubmitting,
                        validator: Validators.username,
                        maxLength: AppConstants.maxUsernameLength,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        label: AppStrings.password,
                        prefixIcon: Icons.lock_outline,
                        enabled: !isSubmitting,
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        maxLength: AppConstants.maxPasswordLength,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? AppStrings.showPassword
                              : AppStrings.hidePassword,
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        label: AppStrings.signIn,
                        icon: Icons.login,
                        isLoading: isSubmitting,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        AppStrings.demoHint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
