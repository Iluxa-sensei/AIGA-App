import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatelessWidget {
  final VoidCallback onBiometricAuth;
  final bool isAvailable;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricAuth,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 3.h),

        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'или',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Auth Button
        OutlinedButton.icon(
          onPressed: onBiometricAuth,
          icon: CustomIconWidget(
            iconName: defaultTargetPlatform == TargetPlatform.iOS
                ? 'face'
                : 'fingerprint',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: Text(
            defaultTargetPlatform == TargetPlatform.iOS
                ? 'Войти с Face ID'
                : 'Войти с отпечатком',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
