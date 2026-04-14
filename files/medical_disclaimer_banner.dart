// lib/shared/widgets/medical_disclaimer_banner.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MedicalDisclaimerBanner extends StatelessWidget {
  final String? customText;
  final bool compact;

  const MedicalDisclaimerBanner({
    super.key,
    this.customText,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = customText ??
        'Medical Disclaimer: This AI analysis is for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. If the burn is larger than your palm or on the face/joints, seek immediate professional care.';

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.xl2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.gavel_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.3,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: AppRadius.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'CLINICAL DISCLAIMER',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurface,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
