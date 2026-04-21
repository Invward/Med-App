// lib/features/results/screens/results_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';
import '../../../shared/widgets/severity_badge.dart';
import '../../../shared/widgets/gradient_button.dart';

class ResultsScreen extends StatelessWidget {
  final File? imageFile;
  final Map<String, dynamic>? result;

  const ResultsScreen({
    super.key,
    this.imageFile,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback demo data
    final label = result?['label'] as String? ?? '2nd Degree Burn';
    final degree = result?['degree'] as int? ?? 2;
    final confidence = result?['confidence'] as double? ?? 0.85;
    final depth = result?['depth'] as String? ?? 'Partial Thickness';
    final cause = result?['cause'] as String? ?? 'Thermal';
    final infectionRisk = result?['infectionRisk'] as String? ?? 'Moderate';
    final description = result?['description'] as String? ??
        'The visual analysis indicates a superficial partial-thickness burn, likely caused by contact with a hot surface or liquid. Characterized by blistering and significant redness, this area requires careful moisture management and protection from infection.';
    final needsHospital = result?['needsHospital'] as bool? ?? true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero image + badge
                _HeroSection(
                  imageFile: imageFile,
                  label: label,
                  degree: degree,
                  confidence: confidence,
                ),
                const SizedBox(height: 28),

                // Bento grid
                _BentoGrid(
                  depth: depth,
                  cause: cause,
                  infectionRisk: infectionRisk,
                ),
                const SizedBox(height: 20),

                // Clinical assessment
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.xl4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Clinical Assessment',
                          style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            needsHospital
                                ? 'Seek immediate professional care'
                                : 'Ready for at-home first aid care',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Primary CTA
                GradientButton(
                  label: 'Scan Another Burn',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(AppRoutes.camera),
                ),

                const SizedBox(height: 24),

                // Disclaimer
                Column(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(height: 8),
                    Text(
                      'MEDICAL DISCLAIMER: THIS AI ANALYSIS IS FOR INFORMATIONAL PURPOSES ONLY AND IS NOT A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE, DIAGNOSIS, OR TREATMENT. IF THE BURN IS LARGER THAN YOUR PALM OR ON THE FACE/JOINTS, SEEK IMMEDIATE PROFESSIONAL CARE.',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 9,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final File? imageFile;
  final String label;
  final int degree;
  final double confidence;

  const _HeroSection({
    required this.imageFile,
    required this.label,
    required this.degree,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.xl4,
              boxShadow: AppColors.medicalGlow,
              color: AppColors.surfaceContainerLow,
            ),
            clipBehavior: Clip.antiAlias,
            child: imageFile != null
                ? Image.file(imageFile!, fit: BoxFit.cover)
                : const Icon(Icons.image_outlined,
                    size: 80, color: AppColors.outline),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.xl4,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        // Badge
        Positioned(
          bottom: -20,
          left: 20,
          right: 20,
          child: SeverityBadge(
            label: label,
            confidence: confidence,
            degree: degree,
          ),
        ),
      ],
    );
  }
}

class _BentoGrid extends StatelessWidget {
  final String depth;
  final String cause;
  final String infectionRisk;

  const _BentoGrid({
    required this.depth,
    required this.cause,
    required this.infectionRisk,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BentoCard(
            icon: Icons.layers_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryFixed.withOpacity(0.4),
            label: 'DEPTH',
            value: depth,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BentoCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.tertiary,
            iconBg: AppColors.tertiaryFixed.withOpacity(0.4),
            label: 'POSSIBLE CAUSE',
            value: cause,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BentoCard(
            icon: Icons.verified_user_outlined,
            iconColor: AppColors.secondary,
            iconBg: AppColors.secondaryFixed.withOpacity(0.3),
            label: 'INFECTION RISK',
            value: '$infectionRisk Risk',
          ),
        ),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _BentoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.lg,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(fontSize: 8),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
