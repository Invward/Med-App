// lib/core/router/app_router.dart
import 'dart:io';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/camera/screens/camera_screen.dart';
import '../../features/camera/screens/photo_preview_screen.dart';
import '../../features/results/screens/results_screen.dart';
import '../../features/firstaid/screens/first_aid_screen.dart';
import '../../features/medical/screens/medical_advice_screen.dart';
import '../../features/emergency/screens/emergency_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const camera = '/camera';
  static const photoPreview = '/photo-preview';
  static const results = '/results';
  static const firstAid = '/first-aid';
  static const medicalAdvice = '/medical-advice';
  static const emergency = '/emergency';
  static const history = '/history';
  static const settings = '/settings';
}

final router = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.camera,
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: AppRoutes.photoPreview,
      builder: (context, state) {
        final file = state.extra as File?;
        return PhotoPreviewScreen(imageFile: file);
      },
    ),
    GoRoute(
      path: AppRoutes.results,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return ResultsScreen(
          imageFile: args?['imageFile'] as File?,
          result: args?['result'] as Map<String, dynamic>?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.firstAid,
      builder: (context, state) {
        final degree = state.extra as int? ?? 2;
        return FirstAidScreen(burnDegree: degree);
      },
    ),
    GoRoute(
      path: AppRoutes.medicalAdvice,
      builder: (context, state) => const MedicalAdviceScreen(),
    ),
    GoRoute(
      path: AppRoutes.emergency,
      builder: (context, state) => const EmergencyScreen(),
    ),
  ],
);
