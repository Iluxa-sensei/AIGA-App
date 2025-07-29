import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> session;
  final VoidCallback onBookingConfirmed;

  const BookingBottomSheetWidget({
    Key? key,
    required this.session,
    required this.onBookingConfirmed,
  }) : super(key: key);

  @override
  State<BookingBottomSheetWidget> createState() =>
      _BookingBottomSheetWidgetState();
}

class _BookingBottomSheetWidgetState extends State<BookingBottomSheetWidget> {
  String _selectedPaymentMethod = 'kaspi';
  bool _isBooking = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'kaspi',
      'name': 'Kaspi Pay',
      'icon': 'payment',
      'description': 'Оплата через Kaspi Pay',
    },
    {
      'id': 'card',
      'name': 'Банковская карта',
      'icon': 'credit_card',
      'description': 'Visa, MasterCard',
    },
    {
      'id': 'cash',
      'name': 'Наличные',
      'icon': 'money',
      'description': 'Оплата в зале',
    },
  ];

  Future<void> _processBooking() async {
    setState(() {
      _isBooking = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isBooking = false;
    });

    widget.onBookingConfirmed();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Тренировка успешно забронирована!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Бронирование',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session Details
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.session['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 4.w,
                              backgroundImage: NetworkImage(
                                widget.session['trainerPhoto'] as String,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.session['trainerName'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${widget.session['time']} • ${widget.session['duration']} мин',
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Стоимость:',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.session['price']} ₸',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Payment Methods
                  Text(
                    'Способ оплаты',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  ..._paymentMethods.map((method) {
                    final isSelected = _selectedPaymentMethod == method['id'];
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method['id'] as String;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: method['icon'] as String,
                                  size: 24,
                                  color: isSelected
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['name'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.lightTheme.colorScheme
                                                .secondary
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      method['description'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  size: 24,
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Book Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isBooking ? null : _processBooking,
                child: _isBooking
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text('Забронировать за ${widget.session['price']} ₸'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
