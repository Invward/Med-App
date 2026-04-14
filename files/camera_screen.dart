// lib/features/camera/screens/camera_screen.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
        _error = 'Camera permission denied';
      });
      return;
    }
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _error = 'No cameras found';
          _isLoading = false;
        });
        return;
      }
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() {
        _hasPermission = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final xFile = await _controller!.takePicture();
      if (mounted) {
        context.push(AppRoutes.photoPreview, extra: File(xFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked != null && mounted) {
      context.push(AppRoutes.photoPreview, extra: File(picked.path));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or loading/error state
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else if (_error != null)
            _ErrorView(message: _error!)
          else if (_hasPermission && _controller != null)
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),

          // Guidelines overlay
          if (_hasPermission && !_isLoading)
            Positioned.fill(
              child: CustomPaint(
                painter: _GuidelinePainter(),
              ),
            ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: AppRadius.full,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: AppRadius.full,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.medical_services_outlined,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'BurnGuard',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),
          ),

          // Instruction hint
          if (_hasPermission && !_isLoading)
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: AppRadius.full,
                  ),
                  child: const Text(
                    'Position burn area within the guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: AppRadius.xl2,
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Shutter
                    GestureDetector(
                      onTap: _hasPermission ? _takePicture : null,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),
                    ),

                    // Flip camera
                    GestureDetector(
                      onTap: () async {
                        if (_cameras.length < 2) return;
                        final current = _controller!.description;
                        final next = _cameras.firstWhere(
                          (c) => c != current,
                          orElse: () => _cameras.first,
                        );
                        await _controller!.dispose();
                        _controller = CameraController(
                          next,
                          ResolutionPreset.high,
                          enableAudio: false,
                        );
                        await _controller!.initialize();
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: AppRadius.xl2,
                            ),
                            child: const Icon(
                              Icons.flip_camera_ios_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Flip',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
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

class _GuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const w = 200.0;
    const h = 200.0;
    const corner = 28.0;
    const len = 40.0;

    // Top-left
    canvas.drawLine(
        Offset(cx - w / 2, cy - h / 2 + corner),
        Offset(cx - w / 2, cy - h / 2),
        paint);
    canvas.drawLine(
        Offset(cx - w / 2, cy - h / 2),
        Offset(cx - w / 2 + corner, cy - h / 2),
        paint);

    // Top-right
    canvas.drawLine(
        Offset(cx + w / 2 - corner, cy - h / 2),
        Offset(cx + w / 2, cy - h / 2),
        paint);
    canvas.drawLine(
        Offset(cx + w / 2, cy - h / 2),
        Offset(cx + w / 2, cy - h / 2 + corner),
        paint);

    // Bottom-left
    canvas.drawLine(
        Offset(cx - w / 2, cy + h / 2 - corner),
        Offset(cx - w / 2, cy + h / 2),
        paint);
    canvas.drawLine(
        Offset(cx - w / 2, cy + h / 2),
        Offset(cx - w / 2 + corner, cy + h / 2),
        paint);

    // Bottom-right
    canvas.drawLine(
        Offset(cx + w / 2 - corner, cy + h / 2),
        Offset(cx + w / 2, cy + h / 2),
        paint);
    canvas.drawLine(
        Offset(cx + w / 2, cy + h / 2),
        Offset(cx + w / 2, cy + h / 2 - corner),
        paint);

    // Center dot
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 4, dotPaint);

    // Crosshair lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0;
    canvas.drawLine(
        Offset(cx - len, cy), Offset(cx + len, cy), linePaint);
    canvas.drawLine(
        Offset(cx, cy - len), Offset(cx, cy + len), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_outlined,
              color: Colors.white54, size: 56),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
