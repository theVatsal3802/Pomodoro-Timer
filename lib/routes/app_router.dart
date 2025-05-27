import 'package:go_router/go_router.dart';
import 'package:pomodoro/screens/splash_screen.dart';
import 'package:pomodoro/screens/time_selection_screen.dart';
import 'package:pomodoro/screens/timer_screen.dart';
import 'package:pomodoro/screens/tutorial_screen.dart';

/// Named routes for the app
class AppRoutes {
  /// Splash screen route
  static const String splash = '/';

  /// Time selection screen route
  static const String timeSelection = '/time-selection';

  /// Timer screen route
  static const String timer = '/timer';

  /// Tutorial screen route
  static const String tutorial = '/tutorial';
}

/// Router configuration for the app
class AppRouter {
  /// GoRouter instance for the app
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.timeSelection,
        builder: (context, state) => const TimeSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.timer,
        builder: (context, state) => const TimerScreen(),
      ),
      GoRoute(
        path: AppRoutes.tutorial,
        builder: (context, state) => const TutorialScreen(),
      ),
    ],
  );
}
