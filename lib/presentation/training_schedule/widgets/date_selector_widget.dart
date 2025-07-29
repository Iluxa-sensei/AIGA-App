import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DateSelectorWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelectorWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  late ScrollController _scrollController;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateWeekDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _generateWeekDates() {
    final now = DateTime.now();
    _weekDates = List.generate(14, (index) {
      return now.add(Duration(days: index - 7));
    });
  }

  void _scrollToSelectedDate() {
    final selectedIndex = _weekDates.indexWhere(
      (date) => _isSameDay(date, widget.selectedDate),
    );
    if (selectedIndex != -1) {
      _scrollController.animateTo(
        selectedIndex * 16.w,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  String _getWeekdayName(DateTime date) {
    const weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _weekDates.length,
        itemBuilder: (context, index) {
          final date = _weekDates[index];
          final isSelected = _isSameDay(date, widget.selectedDate);
          final isToday = _isToday(date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 14.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        width: 1.5,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekdayName(date),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : isToday
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    date.day.toString(),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : isToday
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
