// lib/features/settings/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Medical Disclaimer ──────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: AppRadius.full,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Medical Disclaimer',
                        style: AppTextStyles.headlineMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.xl3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.tertiary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'CRITICAL NOTICE FOR USERS',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This application, BurnGuard, provides information for educational purposes only. The content is not intended to be a substitute for professional medical advice, diagnosis, or treatment.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'If you think you may have a medical emergency, call your doctor, go to the emergency department, or call 911 immediately. Reliance on any information provided by BurnGuard is solely at your own risk.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'BurnGuard does not recommend or endorse any specific tests, physicians, products, procedures, opinions, or other information that may be mentioned in the app.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'EFFECTIVE JAN 2024',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.outline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── App Settings ────────────────────────────────────────────
                Text('App Settings', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 16),

                // Notifications toggle
                _SettingsTile(
                  iconData: Icons.notifications_outlined,
                  iconBg: AppColors.primaryFixed.withOpacity(0.5),
                  iconColor: AppColors.primary,
                  title: 'Push Notifications',
                  subtitle: 'Daily care reminders and alerts',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) => notifier.toggleNotifications(),
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // Privacy & Data
                _SettingsTile(
                  iconData: Icons.lock_outlined,
                  iconBg: AppColors.secondaryContainer.withOpacity(0.3),
                  iconColor: AppColors.secondary,
                  title: 'Data Privacy',
                  subtitle: 'Manage your health data encryption',
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.outlineVariant),
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // Export Records
                _SettingsTile(
                  iconData: Icons.download_outlined,
                  iconBg: AppColors.surfaceContainerHigh,
                  iconColor: AppColors.onSurfaceVariant,
                  title: 'Export Records',
                  subtitle: 'Generate PDF for medical providers',
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.outlineVariant),
                  onTap: () {},
                ),
                const SizedBox(height: 32),

                // ── About ───────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppRadius.xl4,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        bottom: -40,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About BurnGuard',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Designed in collaboration with clinical burn specialists to empower recovery through precise data and compassionate guidance.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VERSION',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '1.0.0 (Stable)',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STATUS',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryFixed,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Verified Engine',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Footer
                const Column(
                  children: [
                    Text(
                      '© 2024 BurnGuard Systems Inc.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.outline,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ALL RIGHTS RESERVED · PATENT PENDING',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        color: AppColors.outlineVariant,
                        letterSpacing: 0.8,
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

class _SettingsTile extends StatelessWidget {
  final IconData iconData;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.iconData,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: AppRadius.xl2,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
