import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../services/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _uploading = false;

  Future<void> _changePhoto(String uid) async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 75,
    );
    if (file == null) return;

    setState(() => _uploading = true);
    try {
      // Upload to Storage first, then save the URL in Firestore and Auth
      final url = await storageService.upload(
        path: 'users/$uid/avatar.jpg',
        bytes: await file.readAsBytes(),
        contentType: file.mimeType ?? 'image/jpeg',
      );
      await userRepository.updatePhoto(uid, url);
      await authService.currentUser?.updatePhotoURL(url);
    } catch (_) {
      if (mounted) showMessage(context, 'Could not upload the photo');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = authService.uid;
    if (uid == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<AppUser?>(
        stream: userRepository.watchUser(uid),
        builder: (context, snap) {
          final user = snap.data;
          final name = user?.name ?? authService.currentUser?.displayName ?? '';
          final email = user?.email ?? authService.currentUser?.email ?? '';
          final photo = user?.photoUrl;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage: photo == null ? null : NetworkImage(photo),
                      child: _uploading
                          ? const CircularProgressIndicator()
                          : photo == null
                              ? Icon(Icons.person,
                                  size: 52, color: theme.colorScheme.onPrimaryContainer)
                              : null,
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: IconButton.filled(
                        tooltip: 'Change photo',
                        onPressed: _uploading ? null : () => _changePhoto(uid),
                        icon: const Icon(Icons.camera_alt_outlined, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                name,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Appearance', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeModeNotifier,
                builder: (context, mode, _) => SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) => themeModeNotifier.value = s.first,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Sign out',
                icon: Icons.logout,
                // The router sends the user back to login automatically
                onPressed: () => authService.signOut(),
              ),
            ],
          );
        },
      ),
    );
  }
}
