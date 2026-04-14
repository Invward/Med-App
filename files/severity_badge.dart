// lib/shared/widgets/severity_badge.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SeverityBadge extends StatelessWidget {
  final String label;
  final double confidence;
  final int degree;

  const SeverityBadge({
    super.key,
    required this.label,
    required this.confidence,
    required this.degree,
  });

  Color get _bgColor {
    switch (degree) {
      case 0:
        return AppColors.secondaryFixed;
      case 1:
        return const Color(0xFFFFE082); // amber
      case 2:
        return AppColors.tertiaryContainer;
      case 3:
        return AppColors.error;
      default:
        return AppColors.surfaceContainerHighest;
    }
  }

  Color get _textColor {
    switch (degree) {
      case 0:
        return AppColors.onSecondaryFixed;
      case 1:
        return const Color(0xFF5D4037);
      case 2:
        return AppColors.onTertiaryContainer;
      case 3:
        return AppColors.onError;
      default:
        return AppColors.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: AppRadius.xl2,
        boxShadow: AppColors.medicalGlow,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SEVERITY LEVEL',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: _textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: _textColor.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CONFIDENCE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: _textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(confidence * 100).round()}%',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small chip-style status badge (Improving / Critical / Resolved)
class StatusChip extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusChip({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (type) {
      case StatusType.positive:
        bg = AppColors.secondaryFixed;
        fg = AppColors.onSecondaryFixed;
        break;
      case StatusType.warning:
        bg = AppColors.tertiaryFixed;
        fg = AppColors.onTertiaryFixed;
        break;
      case StatusType.critical:
        bg = AppColors.tertiaryContainer;
        fg = AppColors.onTertiaryContainer;
        break;
      case StatusType.neutral:
        bg = AppColors.surfaceContainerHighest;
        fg = AppColors.onSurfaceVariant;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.full,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: fg,
        ),
      ),
    );
  }
}

enum StatusType { positive, warning, critical, neutral }
