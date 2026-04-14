// lib/features/medical/screens/medical_advice_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';

class MedicalAdviceScreen extends StatelessWidget {
  const MedicalAdviceScreen({super.key});

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
                // Alert header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.05),
                    borderRadius: AppRadius.xl3,
                    border: Border(
                      left: BorderSide(
                          color: AppColors.tertiary, width: 4),
                    ),
                    boxShadow: AppColors.medicalGlow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: AppRadius.xl2,
                        ),
                        child: const Icon(
                          Icons.emergency_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seek Medical Help Immediately',
                              style: AppTextStyles.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your assessment indicates high-severity risk factors. Delaying professional medical treatment for serious burns can lead to permanent damage or severe infection.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Bento grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hospitalization
                    Expanded(
                      child: _HospitalizationCard(),
                    ),
                    const SizedBox(width: 16),
                    // Infection
                    Expanded(
                      child: _InfectionCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // When to call 911
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.xl3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.call_rounded,
                            color: AppColors.error,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text('When to call 911',
                              style: AppTextStyles.headlineMedium),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...[
                        'Difficulty breathing or smoke inhalation was possible.',
                        'Burn caused by high-voltage electricity or chemicals.',
                        'The patient is showing signs of shock or disorientation.',
                        'Large burns on infants or the elderly.',
                      ].asMap().entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.error,
                                      borderRadius: AppRadius.full,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${e.key + 1}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6),
                                      child: Text(
                                        e.value,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.emergency),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: AppRadius.xl2,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call_rounded,
                                  color: AppColors.primary),
                              SizedBox(width: 10),
                              Text(
                                'Call Emergency Services',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Footer disclaimer
                Column(
                  children: [
                    Text(
                      'LEGAL DISCLAIMER',
                      style: AppTextStyles.labelSmall.copyWith(
                          color: const Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BurnGuard is an educational tool and does not provide professional medical diagnosis. If you are experiencing a medical emergency, call 911 or your local emergency services immediately.',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
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

class _HospitalizationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
        boxShadow: AppColors.medicalGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined,
                  color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hospitalization Indicators',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            (Icons.photo_size_select_small_rounded, 'Large Surface Area',
                'Burn covers more than 10% of total body surface.'),
            (Icons.face_rounded, 'Critical Locations',
                'Any burns involving face, hands, feet, or genitals.'),
            (Icons.dashboard_rounded, 'Deep Thickness',
                'Painless, white, or charred skin (3rd degree burns).'),
          ].map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppRadius.xl,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(e.$1, color: AppColors.tertiary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.$2,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            e.$3,
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
        boxShadow: AppColors.medicalGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.coronavirus_outlined,
                  color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Infection Warning Signs',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            'Fever or chills (systemic response)',
            'Foul-smelling drainage or pus',
            'Increased swelling or spreading redness',
            'The burn area feels increasingly hot',
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.warning_rounded,
                      color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.outlineVariant, height: 1),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withOpacity(0.2),
              borderRadius: AppRadius.xl,
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Check for these every 4–6 hours during healing.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
