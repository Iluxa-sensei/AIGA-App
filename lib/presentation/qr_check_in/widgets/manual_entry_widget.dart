import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualEntryWidget extends StatefulWidget {
  final Function(String) onCodeEntered;
  final bool isLoading;

  const ManualEntryWidget({
    super.key,
    required this.onCodeEntered,
    required this.isLoading,
  });

  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidgetState();
}

class _ManualEntryWidgetState extends State<ManualEntryWidget> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_codeController.text.trim().isNotEmpty) {
      widget.onCodeEntered(_codeController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'keyboard',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Ручной ввод кода',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Введите код сессии для регистрации посещения',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _codeController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Введите код сессии',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                    suffixIcon: _codeController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _codeController.clear();
                              setState(() {});
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (value) => _onSubmit(),
                ),
              ),
              SizedBox(width: 3.w),
              ElevatedButton(
                onPressed:
                    widget.isLoading || _codeController.text.trim().isEmpty
                        ? null
                        : _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Войти',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
