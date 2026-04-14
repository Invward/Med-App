// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';
import '../../../shared/widgets/medical_disclaimer_banner.dart';
import '../../../shared/widgets/severity_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero
                _HeroSection(),
                const SizedBox(height: 24),

                // Quick actions bento
                _QuickActionsBento(),
                const SizedBox(height: 32),

                // Recent scans
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Scans',
                        style: AppTextStyles.headlineSmall),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.history),
                      child: const Text(
                        'View History',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                historyAsync.when(
                  data: (history) => history.isEmpty
                      ? _EmptyHistory()
                      : Column(
                          children: history
                              .take(2)
                              .map((e) => _ScanCard(entry: e))
                              .toList(),
                        ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 24),
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

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to your\nSanctuary',
          style: AppTextStyles.display.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          'Fast, clinical assessment for burn care and recovery monitoring.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        // Scan CTA
        GestureDetector(
          onTap: () => context.push(AppRoutes.camera),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppRadius.xl3,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 48,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: AppRadius.full,
                  ),
                  child: const Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scan New Burn',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-powered triage and assessment',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.blue[100]?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsBento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.emergency),
            child: Container(
              padding: const EdgeInsets.all(24),
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: AppRadius.xl3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.emergency_rounded,
                    color: AppColors.tertiary,
                    size: 32,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Emergency',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 16,
                          )),
                      const SizedBox(height: 2),
                      Text('Immediate first aid',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.firstAid, extra: 2),
            child: Container(
              padding: const EdgeInsets.all(24),
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: AppRadius.xl3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Aid',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 16,
                          )),
                      const SizedBox(height: 2),
                      Text('Step-by-step guide',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                          )),
                    ],
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

class _ScanCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _ScanCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final result = entry['result'] as Map<String, dynamic>?;
    final label = result?['label'] as String? ?? 'Burn Scan';
    final degree = result?['degree'] as int? ?? 0;
    final ts = entry['timestamp'] as String?;
    DateTime? date;
    if (ts != null) date = DateTime.tryParse(ts);

    StatusType statusType;
    String statusLabel;
    switch (degree) {
      case 0:
      case 1:
        statusType = StatusType.positive;
        statusLabel = 'Minor';
        break;
      case 2:
        statusType = StatusType.warning;
        statusLabel = 'Monitor';
        break;
      default:
        statusType = StatusType.critical;
        statusLabel = 'Critical';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppRadius.xl2,
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.outline,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 16,
                        )),
                    StatusChip(text: statusLabel, type: statusType),
                  ],
                ),
                if (date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Scanned: ${_formatDate(date)}',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.outlineVariant,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${_months[d.month - 1]} ${d.day}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_rounded,
            color: AppColors.outlineVariant,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No scans yet',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan a burn to start tracking recovery.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
