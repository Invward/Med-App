// lib/features/camera/screens/photo_preview_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/gradient_button.dart' as gb;

class PhotoPreviewScreen extends ConsumerWidget {
  final File? imageFile;

  const PhotoPreviewScreen({super.key, this.imageFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inference = ref.watch(inferenceProvider);
    final isAnalyzing = inference.status == InferenceStatus.running;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xCCF8F8FD),
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.onSurfaceVariant,
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Review Photo',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Ensure the burn area is clear, well-lit, and in focus for the most accurate analysis.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Image preview
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.xl4,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 48,
                              offset: const Offset(0, 24),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppColors.surfaceContainerLow,
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: AppColors.outline,
                                ),
                              ),
                      ),
                    ),
                    // Edit controls
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _GlassButton(
                            icon: Icons.crop_rounded,
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _GlassButton(
                            icon: Icons.rotate_right_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Quick tip
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.xl2,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withOpacity(0.4),
                          borderRadius: AppRadius.lg,
                        ),
                        child: const Icon(
                          Icons.tips_and_updates_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Tip',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Place the area under indirect sunlight for best color accuracy and shadow reduction.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (isAnalyzing)
                  const _AnalyzingIndicator()
                else ...[
                  gb.GradientButton(
                    label: 'Analyze Burn',
                    icon: Icons.analytics_rounded,
                    onPressed: imageFile != null
                        ? () async {
                            await ref
                                .read(inferenceProvider.notifier)
                                .analyze(imageFile!);
                            if (context.mounted) {
                              final result =
                                  ref.read(inferenceProvider).result;
                              context.push(
                                AppRoutes.results,
                                extra: {
                                  'imageFile': imageFile,
                                  'result': result,
                                },
                              );
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  gb.OutlineButton(
                    label: 'Retake Photo',
                    icon: Icons.replay_rounded,
                    onPressed: () => context.pop(),
                  ),
                ],

                const SizedBox(height: 32),
                // Legal disclaimer
                Column(
                  children: [
                    const Icon(
                      Icons.gavel_rounded,
                      color: Color(0xFFCBD5E1),
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'LEGAL DISCLAIMER: BURNGUARD IS AN AI-POWERED ASSISTANT AND DOES NOT PROVIDE PROFESSIONAL MEDICAL DIAGNOSIS. IF YOU HAVE A SEVERE BURN, PLEASE CONTACT EMERGENCY SERVICES IMMEDIATELY.',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 9,
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

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: AppRadius.full,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.onSurface, size: 22),
      ),
    );
  }
}

class _AnalyzingIndicator extends StatelessWidget {
  const _AnalyzingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xl3,
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Analyzing burn pattern…',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Running on-device AI inference',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
