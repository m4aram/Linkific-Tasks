import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/core/theme/app_colors.dart';
import 'package:shoplite/core/widgets/app_network_image.dart';
import 'package:shoplite/features/auth/logic/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggingOut = false;

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.logoutConfirmTitle),
          content: const Text(AppStrings.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.logout),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    await ref.read(authControllerProvider.notifier).logout();
    // AuthGate now shows the login screen; this widget may be gone.
    if (mounted) setState(() => _isLoggingOut = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(
      authControllerProvider.select((state) => state.user),
    );
    final imageUrl = user?.image;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTitle)),
      body: RefreshIndicator(
        onRefresh: ref.read(authControllerProvider.notifier).refreshUser,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Center(
              child: imageUrl == null
                  ? CircleAvatar(
                      radius: 48,
                      backgroundColor: scheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: scheme.onPrimaryContainer,
                      ),
                    )
                  : AppNetworkImage(
                      url: imageUrl,
                      width: 96,
                      height: 96,
                      borderRadius: BorderRadius.circular(48),
                    ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              user?.fullName ?? AppStrings.guest,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              user?.email ?? AppStrings.profileOffline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(AppStrings.version),
              trailing: Text(AppConstants.appVersion),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text(AppStrings.dataSource),
              trailing: Text(Uri.parse(AppConstants.apiBaseUrl).host),
            ),
            const Divider(),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: _isLoggingOut ? null : _confirmLogout,
              icon: _isLoggingOut
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: AppStrings.loading,
                      ),
                    )
                  : const Icon(Icons.logout),
              label: const Text(AppStrings.logout),
            ),
          ],
        ),
      ),
    );
  }
}
