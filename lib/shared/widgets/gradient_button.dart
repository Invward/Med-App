// lib/shared/widgets/gradient_button.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;
  final BorderRadius? borderRadius;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height = 64,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: borderRadius ?? AppRadius.xl2,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 10),
                Icon(icon, color: Colors.white, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;

  const OutlineButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppRadius.xl2,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
