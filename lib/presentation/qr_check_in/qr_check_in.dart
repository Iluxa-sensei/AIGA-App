import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_viewfinder_widget.dart';
import './widgets/check_in_confirmation_widget.dart';
import './widgets/error_message_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/nfc_check_in_widget.dart';

class QrCheckIn extends StatefulWidget {
  const QrCheckIn({super.key});

  @override
  State<QrCheckIn> createState() => _QrCheckInState();
}

class _QrCheckInState extends State<QrCheckIn> with TickerProviderStateMixin {
  // Camera related
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashlightOn = false;

  // Scanning states
  bool _isScanning = false;
  bool _isProcessing = false;
  bool _showManualEntry = false;
  bool _showConfirmation = false;
  bool _showError = false;

  // NFC related
  bool _isNfcAvailable = true;
  bool _isNfcScanning = false;

  // Error handling
  String _errorMessage = '';
  String? _errorType;

  // Session data
  Map<String, dynamic>? _sessionData;

  // Mock session data for demonstration
  final List<Map<String, dynamic>> _mockSessions = [
    {
      "id": "12345",
      "name": "Грэпплинг для начинающих",
      "trainer": "Алексей Иванов",
      "time": "18:00 - 19:30",
      "location": "Зал №1",
      "xp": 10,
      "streakMilestone": false,
      "streak": 3,
    },
    {
      "id": "67890",
      "name": "Продвинутый грэпплинг",
      "trainer": "Дмитрий Петров",
      "time": "19:45 - 21:15",
      "location": "Зал №2",
      "xp": 15,
      "streakMilestone": true,
      "streak": 5,
    },
    {
      "id": "NFC_SESSION_12345",
      "name": "Вечерняя тренировка",
      "trainer": "Сергей Козлов",
      "time": "20:00 - 21:30",
      "location": "Зал №1",
      "xp": 10,
      "streakMilestone": false,
      "streak": 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        setState(() {
          _showError = true;
          _errorMessage =
              'Для сканирования QR-кодов необходимо разрешение на использование камеры';
          _errorType = 'camera_permission';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _showError = true;
          _errorMessage = 'Камера не найдена на устройстве';
          _errorType = 'camera_permission';
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _startScanning();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showError = true;
          _errorMessage =
              'Ошибка инициализации камеры. Попробуйте перезапустить приложение.';
          _errorType = 'camera_permission';
        });
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      // Ignore settings that aren't supported
    }
  }

  void _startScanning() {
    if (!_isCameraInitialized || _isScanning) return;

    setState(() {
      _isScanning = true;
      _showError = false;
    });

    // Simulate QR code detection after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isScanning) {
        _simulateQrDetection('12345');
      }
    });
  }

  void _simulateQrDetection(String qrCode) {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _isScanning = false;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Find session data
    final sessionData = _mockSessions.firstWhere(
      (session) => session['id'] == qrCode,
      orElse: () => {},
    );

    if (sessionData.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage =
            'QR-код не распознан или недействителен. Проверьте код и попробуйте снова.';
        _errorType = 'invalid_qr';
        _isProcessing = false;
      });
      return;
    }

    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _sessionData = sessionData;
          _showConfirmation = true;
          _isProcessing = false;
        });
      }
    });
  }

  void _toggleFlashlight() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      await _cameraController!
          .setFlashMode(_isFlashlightOn ? FlashMode.off : FlashMode.torch);
      setState(() {
        _isFlashlightOn = !_isFlashlightOn;
      });
    } catch (e) {
      // Flash not supported
    }
  }

  void _handleManualEntry(String code) {
    setState(() {
      _isProcessing = true;
      _showError = false;
    });

    // Simulate processing
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _simulateQrDetection(code);
      }
    });
  }

  void _handleNfcDetection(String nfcData) {
    setState(() {
      _isNfcScanning = true;
    });

    // Simulate NFC processing
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _simulateQrDetection(nfcData);
        setState(() {
          _isNfcScanning = false;
        });
      }
    });
  }

  void _retryScanning() {
    setState(() {
      _showError = false;
      _showConfirmation = false;
      _sessionData = null;
    });
    _startScanning();
  }

  void _showManualEntryDialog() {
    setState(() {
      _showManualEntry = true;
      _showError = false;
    });
  }

  void _closeConfirmation() {
    setState(() {
      _showConfirmation = false;
      _sessionData = null;
    });
    Navigator.pop(context);
  }

  void _handleShareSuccess() {
    // Simulate social sharing success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Успех поделен в социальных сетях!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Header with close button
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
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
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'QR Регистрация',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Camera viewfinder
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: CameraViewfinderWidget(
                      cameraController: _cameraController,
                      isFlashlightOn: _isFlashlightOn,
                      onFlashlightToggle: _toggleFlashlight,
                      isScanning: _isScanning,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Manual entry section
                if (_showManualEntry || _showError)
                  ManualEntryWidget(
                    onCodeEntered: _handleManualEntry,
                    isLoading: _isProcessing,
                  ),

                SizedBox(height: 2.h),

                // NFC check-in section
                NfcCheckInWidget(
                  onNfcDetected: _handleNfcDetection,
                  isNfcAvailable: _isNfcAvailable,
                  isScanning: _isNfcScanning,
                ),

                SizedBox(height: 2.h),

                // Error message
                if (_showError)
                  ErrorMessageWidget(
                    errorMessage: _errorMessage,
                    errorType: _errorType,
                    onRetry: _retryScanning,
                    onManualEntry: _showManualEntryDialog,
                  ),

                SizedBox(height: 4.h),
              ],
            ),

            // Processing overlay
            if (_isProcessing)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.secondaryLight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Обработка...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Confirmation modal
            if (_showConfirmation && _sessionData != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CheckInConfirmationWidget(
                  sessionData: _sessionData!,
                  onClose: _closeConfirmation,
                  onShareSuccess: _handleShareSuccess,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
