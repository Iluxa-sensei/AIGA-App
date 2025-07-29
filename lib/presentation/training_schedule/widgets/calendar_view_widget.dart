import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarViewWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Map<String, dynamic>> sessions;
  final Function(Map<String, dynamic>) onSessionTap;

  const CalendarViewWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.sessions,
    required this.onSessionTap,
  }) : super(key: key);

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _pageController = PageController();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));

    final days = <DateTime>[];
    for (int i = 0; i < 42; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
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

  List<Map<String, dynamic>> _getSessionsForDate(DateTime date) {
    return widget.sessions.where((session) {
      final sessionDate = DateTime.parse(session['date'] as String);
      return _isSameDay(sessionDate, date);
    }).toList();
  }

  String _getMonthName(int month) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar Header
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth =
                        DateTime(_currentMonth.year, _currentMonth.month - 1);
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'chevron_left',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth =
                        DateTime(_currentMonth.year, _currentMonth.month + 1);
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'chevron_right',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        // Weekday Headers
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 2.h),

        // Calendar Grid
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.8,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final days = _getDaysInMonth(_currentMonth);
                final date = days[index];
                final isCurrentMonth = date.month == _currentMonth.month;
                final isSelected = _isSameDay(date, widget.selectedDate);
                final isToday = _isToday(date);
                final sessionsForDate = _getSessionsForDate(date);
                final hasSession = sessionsForDate.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    widget.onDateSelected(date);
                    if (hasSession) {
                      _showSessionsForDate(date, sessionsForDate);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : isToday
                              ? AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
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
                          date.day.toString(),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onSecondary
                                : isCurrentMonth
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                            fontWeight: isSelected || isToday
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (hasSession) ...[
                          SizedBox(height: 0.5.h),
                          Container(
                            width: 1.5.w,
                            height: 1.5.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onSecondary
                                  : AppTheme.lightTheme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showSessionsForDate(
      DateTime date, List<Map<String, dynamic>> sessions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
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
                  Text(
                    '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(session['trainerPhoto'] as String),
                      ),
                      title: Text(
                        session['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${session['time']} • ${session['trainerName']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      trailing: Text(
                        '${session['price']} ₸',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onSessionTap(session);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
