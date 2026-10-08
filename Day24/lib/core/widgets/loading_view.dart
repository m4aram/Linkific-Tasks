import 'package:flutter/material.dart';
import 'package:shoplite/core/constants/app_strings.dart';

/// Centered spinner used for every full-area loading state.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(semanticsLabel: AppStrings.loading),
    );
  }
}
