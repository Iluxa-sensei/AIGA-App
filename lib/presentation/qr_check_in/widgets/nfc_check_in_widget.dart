import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NfcCheckInWidget extends StatefulWidget {
  final Function(String) onNfcDetected;
  final bool isNfcAvailable;
  final bool isScanning;

  const NfcCheckInWidget({
    super.key,
    required this.onNfcDetected,
    required this.isNfcAvailable,
    required this.isScanning,
  });

  @override
  State<NfcCheckInWidget> createState() => _NfcCheckInWidgetState();
}

class _NfcCheckInWidgetState extends State<NfcCheckInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isScanning) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NfcCheckInWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateNfcTap() {
    // Simulate NFC detection with mock session data
    widget.onNfcDetected('NFC_SESSION_12345');
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isNfcAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'nfc',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'NFC Регистрация',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // NFC tap area
          GestureDetector(
            onTap: widget.isScanning ? null : _simulateNfcTap,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isScanning ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: widget.isScanning
                          ? AppTheme.secondaryLight.withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isScanning
                            ? AppTheme.secondaryLight
                            : AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'contactless',
                        color: widget.isScanning
                            ? AppTheme.secondaryLight
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            widget.isScanning
                ? 'Поднесите устройство к NFC метке...'
                : 'Нажмите для NFC регистрации',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),

          if (widget.isScanning) ...[
            SizedBox(height: 2.h),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.secondaryLight,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
