import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/routes/app_router.dart';
import 'package:pomodoro/theme/app_theme.dart';

/// Splash screen displayed when the app starts
class SplashScreen extends StatefulWidget {
  /// Default constructor for SplashScreen
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController.repeat(reverse: true);

    // Automatically navigate to time selection screen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      // Set a flag to prevent multiple navigation attempts
      if (!mounted || _isNavigating) return;

      setState(() {
        _isNavigating = true;
      });

      context.go(AppRoutes.timeSelection);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon with glowing effect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.focusColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.timer,
                size: 80,
                color: AppTheme.focusColor,
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                )
                .then(delay: const Duration(milliseconds: 200))
                .animate(controller: _pulseController)
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                ),

            const SizedBox(height: 40),

            // App name
            Text(
              'Pomodoro Timer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            )
                .animate(delay: const Duration(milliseconds: 300))
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                )
                .slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 20),

            // Tagline
            Text(
              'Focus on what matters',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ).animate(delay: const Duration(milliseconds: 500)).fadeIn(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: 60),

            // Loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.focusColor,
                ),
                strokeWidth: 3,
              ),
            ).animate(delay: const Duration(milliseconds: 600)).fadeIn(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
