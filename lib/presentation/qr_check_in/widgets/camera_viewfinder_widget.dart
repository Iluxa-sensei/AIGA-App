import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraViewfinderWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isFlashlightOn;
  final VoidCallback onFlashlightToggle;
  final bool isScanning;

  const CameraViewfinderWidget({
    super.key,
    required this.cameraController,
    required this.isFlashlightOn,
    required this.onFlashlightToggle,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Camera preview
          cameraController != null && cameraController!.value.isInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(cameraController!),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Инициализация камеры...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          // Scanning overlay frame
          Center(
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isScanning
                      ? AppTheme.secondaryLight
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Animated corner indicators
                  ...List.generate(4, (index) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      top: index < 2 ? 0 : null,
                      bottom: index >= 2 ? 0 : null,
                      left: index % 2 == 0 ? 0 : null,
                      right: index % 2 == 1 ? 0 : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isScanning
                              ? AppTheme.secondaryLight.withValues(alpha: 0.8)
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Flashlight toggle button
          Positioned(
            top: 2.h,
            right: 4.w,
            child: GestureDetector(
              onTap: onFlashlightToggle,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: isFlashlightOn ? 'flash_on' : 'flash_off',
                  color: isFlashlightOn
                      ? AppTheme.secondaryLight
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
          ),

          // Scanning instruction text
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                isScanning
                    ? 'Сканирование QR-кода...'
                    : 'Расположите QR-код в рамке',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
