// lib/features/history/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';
import '../../../shared/widgets/severity_badge.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('History', style: AppTextStyles.display.copyWith(fontSize: 36)),
                const SizedBox(height: 6),
                Text(
                  'Review your past clinical assessments and monitor recovery trends over time.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Search bar
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.xl2,
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(Icons.search_rounded, color: AppColors.outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search assessments...',
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),

          // History list
          historyAsync.when(
            data: (history) => history.isEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(child: _EmptyHistory()),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _HistoryCard(entry: history[i]),
                        childCount: history.length,
                      ),
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
          ),

          // Insights bento
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            sliver: SliverToBoxAdapter(
              child: historyAsync.maybeWhen(
                data: (h) => h.isNotEmpty ? _InsightsBento(entries: h) : const SizedBox(),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const _HistoryCard({required this.entry});

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
        statusLabel = 'Improving';
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
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
        boxShadow: AppColors.cardShadow,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppRadius.xl3,
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: AppRadius.xl2,
              ),
              child: const Icon(Icons.medical_services_outlined,
                  color: AppColors.outline, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (date != null)
                        Text(
                          _formatDate(date).toUpperCase(),
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      StatusChip(text: statusLabel, type: statusType),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(label, style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.onSurfaceVariant, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        result?['depth'] as String? ?? 'Unknown depth',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['JAN','FEB','MAR','APR','MAY','JUN',
                    'JUL','AUG','SEP','OCT','NOV','DEC'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _InsightsBento extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const _InsightsBento({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Calculate a simple recovery score (higher degree = lower score)
    final avgDegree = entries.isEmpty
        ? 0.0
        : entries
                .map((e) => (e['result']?['degree'] as int? ?? 0))
                .reduce((a, b) => a + b) /
            entries.length;
    final recoveryScore = ((1 - avgDegree / 3) * 100).round().clamp(0, 100);

    final lastEntry = entries.first;
    final lastTs = lastEntry['timestamp'] as String?;
    DateTime? lastDate;
    if (lastTs != null) lastDate = DateTime.tryParse(lastTs);
    final daysSince = lastDate != null
        ? DateTime.now().difference(lastDate).inDays
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Insights', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        Row(
          children: [
            // Recovery score - large card
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.xl4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.trending_up_rounded,
                        color: Colors.white, size: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$recoveryScore%',
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'RECOVERY SCORE',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Two small cards
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 72,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: AppRadius.xl3,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: AppColors.secondary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$daysSince Day${daysSince != 1 ? 's' : ''} Since Last Update',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 72,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: AppRadius.xl3,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.medical_information_outlined,
                            color: AppColors.tertiary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${entries.length} Total Assessment${entries.length != 1 ? 's' : ''}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        children: [
          const Icon(Icons.history_rounded, color: AppColors.outlineVariant, size: 48),
          const SizedBox(height: 16),
          Text('No assessments yet',
              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text('Scan a burn to start tracking your recovery journey.',
              style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
