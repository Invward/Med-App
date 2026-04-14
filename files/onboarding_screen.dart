// lib/features/onboarding/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.visibility_outlined,
      title: 'Fast & Accurate',
      body:
          'AI-powered assessment provides immediate classification of burns with clinical precision in seconds.',
      showScanner: true,
    ),
    _OnboardingPage(
      icon: Icons.security_rounded,
      title: 'Privacy First',
      body:
          'Your medical data is encrypted end-to-end. We never share your clinical images with third parties without consent.',
      showPrivacyGrid: true,
    ),
    _OnboardingPage(
      icon: Icons.medical_information_outlined,
      title: 'Professional Advice',
      body:
          'Bridge the gap between incident and recovery with expert-guided clinical suggestions and triage steps.',
      showDisclaimer: true,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.3),
                borderRadius: AppRadius.full,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed.withOpacity(0.15),
                borderRadius: AppRadius.full,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) =>
                        setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) =>
                        _OnboardingPageView(page: _pages[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    children: [
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (i) {
                          final active = i == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.surfaceContainerHighest,
                              borderRadius: AppRadius.full,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 28),
                      GradientButton(
                        label: _currentPage < _pages.length - 1
                            ? 'Next'
                            : 'Get Started',
                        icon: _currentPage < _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        onPressed: _nextPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String body;
  final bool showScanner;
  final bool showPrivacyGrid;
  final bool showDisclaimer;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
    this.showScanner = false,
    this.showPrivacyGrid = false,
    this.showDisclaimer = false,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        children: [
          // Hero card
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: AppRadius.xl4,
                boxShadow: AppColors.medicalGlow,
              ),
              child: _buildHeroContent(),
            ),
          ),
          const SizedBox(height: 36),
          // Text
          Text(
            page.title,
            style: AppTextStyles.display.copyWith(fontSize: 34),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            page.body,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeroContent() {
    if (page.showScanner) return _ScannerIllustration();
    if (page.showPrivacyGrid) return _PrivacyGrid();
    if (page.showDisclaimer) return _DisclaimerCard();
    return const SizedBox();
  }
}

class _ScannerIllustration extends StatefulWidget {
  @override
  State<_ScannerIllustration> createState() => _ScannerIllustrationState();
}

class _ScannerIllustrationState extends State<_ScannerIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scan;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scan = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x0A005AB3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Pulsing circle
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Container(
            width: 180 + _scan.value * 20,
            height: 180 + _scan.value * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.15 + _scan.value * 0.1),
                width: 2,
              ),
            ),
          ),
        ),
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryFixed,
              width: 3,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(
            Icons.visibility_outlined,
            color: AppColors.primary,
            size: 72,
          ),
        ),
        // Scan line
        AnimatedBuilder(
          animation: _scan,
          builder: (_, __) => Positioned(
            top: 60 + _scan.value * 120,
            left: 40,
            right: 40,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.primaryContainer,
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: AppRadius.xl3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: AppColors.primary,
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Data Encryption',
                    style: AppTextStyles.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PrivacyTile(
                  icon: Icons.lock_person_rounded,
                  label: 'GDPR Compliant',
                  color: AppColors.secondaryFixed,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PrivacyTile(
                  icon: Icons.cloud_off_rounded,
                  label: 'Local Processing',
                  color: AppColors.surfaceContainerLow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PrivacyTile(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.secondary, size: 28),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.tertiaryFixed.withOpacity(0.2),
          borderRadius: AppRadius.xl3,
          border: Border.all(
            color: AppColors.tertiaryFixed.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.medical_information_outlined,
                  color: AppColors.tertiary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Medical Disclaimer',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...[
              'BurnGuard is a triage support tool, not a diagnostic medical device.',
              'Always consult with a licensed medical professional for treatment.',
              'In case of emergency, call local emergency services immediately.',
            ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.tertiary,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
