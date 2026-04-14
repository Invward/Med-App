// lib/features/firstaid/screens/first_aid_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';
import '../../../shared/widgets/medical_disclaimer_banner.dart';

class FirstAidScreen extends StatelessWidget {
  final int burnDegree;

  const FirstAidScreen({super.key, this.burnDegree = 2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        AppColors.tertiaryContainer.withOpacity(0.1),
                    borderRadius: AppRadius.full,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emergency_rounded,
                          color: AppColors.tertiary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'IMMEDIATE ACTION REQUIRED',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.tertiary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('First Aid Guidance',
                    style: AppTextStyles.display.copyWith(
                        fontSize: 36, height: 1.1)),
                const SizedBox(height: 8),
                Text(
                  'Follow these clinically validated steps immediately after a burn injury to minimize tissue damage and promote healing.',
                  style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 28),

                // Step 1
                _StepCard(
                  stepNumber: '01',
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.primaryFixed.withOpacity(0.3),
                  title: 'Cool with running water for 20 mins',
                  description:
                      'Place the burn under lukewarm (not cold) running water. This dissipates heat and prevents the burn from deepening into the skin layers.',
                  accentColor: AppColors.primary,
                  isLarge: true,
                  footer: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withOpacity(0.3),
                          borderRadius: AppRadius.full,
                        ),
                        child: const Icon(Icons.timer_outlined,
                            color: AppColors.primary, size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '20 minute countdown recommended',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Step 2
                _StepCard(
                  stepNumber: '02',
                  icon: Icons.back_hand_outlined,
                  iconColor: AppColors.secondary,
                  iconBg: AppColors.secondaryFixed.withOpacity(0.3),
                  title: 'Remove jewelry/clothing near burn',
                  description:
                      'Carefully remove restrictive items before swelling starts. Caution: If clothing is stuck to the burn, do not pull it off; leave it in place.',
                  accentColor: AppColors.secondary,
                  isLarge: false,
                ),
                const SizedBox(height: 16),

                // Step 3 — wide with image placeholder
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: AppRadius.xl4,
                    boxShadow: AppColors.medicalGlow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: AppRadius.xl2,
                          ),
                          child: const Icon(
                            Icons.medical_services_outlined,
                            color: AppColors.outline,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withOpacity(0.3),
                          borderRadius: AppRadius.lg,
                        ),
                        child: const Icon(Icons.layers_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'STEP 03',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text('Cover with clean cling film',
                          style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Layer cling film over the burn (don\'t wrap tightly) or use a clean non-fluffy dressing. This protects the area from infection while keeping it visible for medical inspection.',
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Do's and Don'ts
                Text("DOs & DON'Ts",
                    style: AppTextStyles.headlineSmall),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Don'ts
                    Expanded(
                      child: _DosDontsCard(
                        title: 'Critical Avoidance',
                        titleColor: AppColors.tertiary,
                        icon: Icons.cancel_rounded,
                        items: const [
                          _DosDontsItem(
                            icon: Icons.ac_unit_rounded,
                            title: "DON'T use ice or ice water",
                            subtitle:
                                'Extreme cold can further damage tissue and cause frostbite.',
                          ),
                          _DosDontsItem(
                            icon: Icons.kitchen_rounded,
                            title: "DON'T use butter or oils",
                            subtitle:
                                'These trap heat and can introduce bacteria.',
                          ),
                          _DosDontsItem(
                            icon: Icons.personal_injury_rounded,
                            title: "DON'T pop blisters",
                            subtitle:
                                'Blisters are a natural sterile barrier against infection.',
                          ),
                        ],
                        accentColor: AppColors.tertiary,
                        bgColor:
                            AppColors.tertiaryContainer.withOpacity(0.05),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Do's
                    Expanded(
                      child: _DosDontsCard(
                        title: 'Safety Best Practices',
                        titleColor: AppColors.secondary,
                        icon: Icons.check_circle_outline_rounded,
                        items: const [
                          _DosDontsItem(
                            icon: Icons.arrow_upward_rounded,
                            title: 'DO elevate the burn',
                            subtitle:
                                'Keep the burned area above the heart to reduce swelling.',
                          ),
                          _DosDontsItem(
                            icon: Icons.medication_outlined,
                            title: 'DO take pain relief',
                            subtitle:
                                'Paracetamol or ibuprofen can help manage discomfort.',
                          ),
                          _DosDontsItem(
                            icon: Icons.call_outlined,
                            title: 'DO call for help if needed',
                            subtitle:
                                'Contact emergency services for large or facial burns.',
                          ),
                        ],
                        accentColor: AppColors.secondary,
                        bgColor:
                            AppColors.secondaryContainer.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Emergency button
                GestureDetector(
                  onTap: () => context.push(AppRoutes.emergency),
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer.withOpacity(0.3),
                      borderRadius: AppRadius.xl2,
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emergency_share_rounded,
                            color: AppColors.error),
                        SizedBox(width: 12),
                        Text(
                          'Call Emergency Services',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const MedicalDisclaimerBanner(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String stepNumber;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final Color accentColor;
  final bool isLarge;
  final Widget? footer;

  const _StepCard({
    required this.stepNumber,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.accentColor,
    this.isLarge = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl4,
        boxShadow: isLarge ? AppColors.medicalGlow : AppColors.cardShadow,
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.xl,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'STEP $stepNumber',
            style: AppTextStyles.labelSmall.copyWith(color: accentColor),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: isLarge
                ? AppTextStyles.headlineMedium
                : AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium,
          ),
          if (footer != null) ...[
            const SizedBox(height: 20),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _DosDontsCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData icon;
  final List<_DosDontsItem> items;
  final Color accentColor;
  final Color bgColor;

  const _DosDontsCard({
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.items,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: titleColor, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: titleColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _ItemRow(item: item, accent: accentColor)),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final _DosDontsItem item;
  final Color accent;

  const _ItemRow({required this.item, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: AppRadius.xl,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: accent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DosDontsItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DosDontsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
