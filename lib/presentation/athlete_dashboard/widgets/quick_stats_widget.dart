import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final int upcomingSessions;
  final int currentStreak;
  final int totalXP;
  final double nextBeltProgress;

  const QuickStatsWidget({
    super.key,
    required this.upcomingSessions,
    required this.currentStreak,
    required this.totalXP,
    required this.nextBeltProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: 'event',
              title: 'Предстоящие',
              value: upcomingSessions.toString(),
              subtitle: 'сессии',
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              icon: 'local_fire_department',
              title: 'Серия',
              value: currentStreak.toString(),
              subtitle: 'дней',
              color: AppTheme.warningLight,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              icon: 'stars',
              title: 'Общий XP',
              value: totalXP.toString(),
              subtitle: 'очков',
              color: AppTheme.successLight,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              icon: 'trending_up',
              title: 'Пояс',
              value: '${(nextBeltProgress * 100).toInt()}%',
              subtitle: 'прогресс',
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
