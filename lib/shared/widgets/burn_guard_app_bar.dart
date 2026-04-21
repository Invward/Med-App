// lib/shared/widgets/burn_guard_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class BurnGuardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final List<Widget>? actions;

  const BurnGuardAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ColorFilter.matrix(<double>[
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 0.8, 0,
        ]),
        child: AppBar(
          backgroundColor: const Color(0xCCF8F8FD),
          elevation: 0,
          shadowColor: const Color(0x100A84FF),
          leading: showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: AppColors.onSurfaceVariant,
                  onPressed: () => context.pop(),
                )
              : null,
          titleSpacing: showBack ? 0 : 24,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!showBack) ...[
                const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  title ?? 'BurnGuard',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ] else ...[
                Text(
                  title ?? '',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ],
          ),
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
