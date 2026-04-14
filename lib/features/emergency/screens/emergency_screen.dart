// lib/features/emergency/screens/emergency_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/burn_guard_app_bar.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _call911() async {
    final uri = Uri(scheme: 'tel', path: '911');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BurnGuardAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title
                Text(
                  'Emergency Help',
                  style: AppTextStyles.display.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Immediate assistance required for severe burn trauma.',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 32),

                // 911 button with pulse animation
                _EmergencyCallButton(onTap: _call911),
                const SizedBox(height: 28),

                // Location card
                _LocationCard(),
                const SizedBox(height: 20),

                // Medical ID
                _MedicalIdCard(),
                const SizedBox(height: 20),

                // Share burn report
                _ShareReportCard(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCallButton extends StatefulWidget {
  final VoidCallback onTap;

  const _EmergencyCallButton({required this.onTap});

  @override
  State<_EmergencyCallButton> createState() => _EmergencyCallButtonState();
}

class _EmergencyCallButtonState extends State<_EmergencyCallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulse = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, child) => Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Opacity(
              opacity: (1 - _pulse.value).clamp(0, 1),
              child: Container(
                width: double.infinity,
                height: 140 + _pulse.value * 30,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.xl4,
                  color: AppColors.error.withOpacity(0.15),
                ),
              ),
            ),
            child!,
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: AppRadius.xl4,
            boxShadow: AppColors.emergencyGlow,
          ),
          child: const Column(
            children: [
              Icon(
                Icons.emergency_share_rounded,
                color: Colors.white,
                size: 52,
              ),
              SizedBox(height: 12),
              Text(
                'CALL EMERGENCY SERVICES\n(911)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppRadius.xl,
                ),
                child: const Icon(Icons.location_on_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT LOCATION',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Locating your position…',
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadius.xl2,
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined,
                      color: AppColors.outline, size: 36),
                  SizedBox(height: 8),
                  Text(
                    'Map view (GPS required)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalIdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.xl3,
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_rounded,
                      color: AppColors.secondary, size: 22),
                  const SizedBox(width: 10),
                  Text('Medical ID',
                      style: AppTextStyles.headlineSmall),
                ],
              ),
              Text(
                'View All',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...[
            ('Blood Type', 'O Positive'),
            ('Allergies', 'Penicillin, Latex'),
            ('Conditions', 'Asthma'),
          ].map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppRadius.xl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.$1,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        )),
                    Text(
                      e.$2,
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 15),
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

class _ShareReportCard extends StatefulWidget {
  @override
  State<_ShareReportCard> createState() => _ShareReportCardState();
}

class _ShareReportCardState extends State<_ShareReportCard> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xl3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share Burn Report',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  'Sends assessment data directly to responding ambulance crew.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
