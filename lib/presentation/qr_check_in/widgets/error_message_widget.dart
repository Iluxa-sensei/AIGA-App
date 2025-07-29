import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  final String? errorType;
  final VoidCallback? onRetry;
  final VoidCallback? onManualEntry;

  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
    this.errorType,
    this.onRetry,
    this.onManualEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Error icon
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.errorLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getErrorIcon(),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Error title
          Text(
            _getErrorTitle(),
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.errorLight,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          // Error message
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),

          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              if (onRetry != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: Text(
                      'Повторить',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                if (onManualEntry != null) SizedBox(width: 3.w),
              ],
              if (onManualEntry != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onManualEntry,
                    icon: CustomIconWidget(
                      iconName: 'keyboard',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: Text(
                      'Ввести код',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getErrorIcon() {
    switch (errorType) {
      case 'invalid_qr':
        return 'qr_code_scanner';
      case 'already_checked_in':
        return 'check_circle';
      case 'session_time':
        return 'schedule';
      case 'camera_permission':
        return 'camera_alt';
      case 'network':
        return 'wifi_off';
      default:
        return 'error';
    }
  }

  String _getErrorTitle() {
    switch (errorType) {
      case 'invalid_qr':
        return 'Неверный QR-код';
      case 'already_checked_in':
        return 'Уже зарегистрирован';
      case 'session_time':
        return 'Время сессии';
      case 'camera_permission':
        return 'Доступ к камере';
      case 'network':
        return 'Нет соединения';
      default:
        return 'Ошибка';
    }
  }
}
