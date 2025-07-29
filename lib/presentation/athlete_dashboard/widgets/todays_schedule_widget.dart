import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodaysScheduleWidget extends StatelessWidget {
  final List<Map<String, dynamic>> todaysSchedule;
  final VoidCallback onViewAll;
  final Function(Map<String, dynamic>) onSessionTap;
  final Function(Map<String, dynamic>) onQuickCheckIn;

  const TodaysScheduleWidget({
    super.key,
    required this.todaysSchedule,
    required this.onViewAll,
    required this.onSessionTap,
    required this.onQuickCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Расписание на сегодня',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'Все',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          todaysSchedule.isEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'event_available',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Нет тренировок на сегодня',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Отличное время для отдыха!',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 25.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: todaysSchedule.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final session = todaysSchedule[index];
                      return _buildScheduleCard(session);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> session) {
    final bool isUpcoming = (session['status'] as String) == 'upcoming';
    final bool isCompleted = (session['status'] as String) == 'completed';

    return GestureDetector(
      onTap: () => onSessionTap(session),
      onLongPress: () => onQuickCheckIn(session),
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isUpcoming
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successLight.withValues(alpha: 0.1)
                        : isUpcoming
                            ? AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: isCompleted
                        ? 'check_circle'
                        : isUpcoming
                            ? 'schedule'
                            : 'sports_martial_arts',
                    color: isCompleted
                        ? AppTheme.successLight
                        : isUpcoming
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (isUpcoming)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Скоро',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              session['time'] as String,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              session['type'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    session['trainer'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    session['location'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
