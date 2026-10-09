import 'package:go_router/go_router.dart';

import '../widgets/placeholder_screen.dart';

/// Route paths, defined once so screens never type them by hand.
class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const workouts = '/workouts';
  static const workoutForm = '/workouts/form';
  static const progress = '/progress';
  static const profile = '/profile';
  static const goals = '/goals';
  static const bmi = '/bmi';
  static const water = '/water';
}

// Every route shows a placeholder for now. Replace each one with its real
// screen as the feature is built.
// TODO(task 3): wrap the four tabs in a shell route with a bottom navigation bar.
// TODO(task 4): add a redirect that sends signed-out users to the login route.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const PlaceholderScreen(title: 'Login'),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const PlaceholderScreen(title: 'Register'),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Forgot password'),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const PlaceholderScreen(title: 'Home'),
    ),
    GoRoute(
      path: AppRoutes.workouts,
      builder: (context, state) => const PlaceholderScreen(title: 'Workouts'),
    ),
    GoRoute(
      path: AppRoutes.workoutForm,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Add / edit workout'),
    ),
    GoRoute(
      path: AppRoutes.progress,
      builder: (context, state) => const PlaceholderScreen(title: 'Progress'),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
    ),
    GoRoute(
      path: AppRoutes.goals,
      builder: (context, state) => const PlaceholderScreen(title: 'Goals'),
    ),
    GoRoute(
      path: AppRoutes.bmi,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'BMI calculator'),
    ),
    GoRoute(
      path: AppRoutes.water,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Water tracker'),
    ),
  ],
);
